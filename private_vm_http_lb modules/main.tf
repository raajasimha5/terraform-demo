
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
  }
}

locals {
  instance_template_name = "${var.name_prefix}-tmpl"
  igm_name               = "${var.name_prefix}-mig"
  hc_name                = "${var.name_prefix}-hc"
  backend_name           = "${var.name_prefix}-backend"
  url_map_name           = "${var.name_prefix}-urlmap"
  proxy_name             = "${var.name_prefix}-proxy"
  fr_name                = "${var.name_prefix}-http-fr"
  port_name              = "http"

  default_startup = <<-EOT
    #!/bin/bash
    set -euxo pipefail
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y nginx
    echo "<h1> Welcome to Nginx </h1>" > /var/www/html/index.html
    systemctl enable nginx
    systemctl start nginx
  EOT
}



# Instance template without public IP (private VM)
resource "google_compute_instance_template" "tmpl" {
  name_prefix  = local.instance_template_name
  project      = var.project_id
  machine_type = var.machine_type

  disk {
    source_image = "projects/${var.image_project}/global/images/family/${var.image_family}"
    auto_delete  = true
    boot         = true
    type         = "PERSISTENT"
    disk_size_gb = 10
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    # No access_config => NO public IP
  }

  tags = var.tags

  metadata = {
    startup-script = var.startup_script != null ? var.startup_script : local.default_startup
  }

  service_account {
    email  = var.service_account_email != null ? var.service_account_email : "default"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
}

# Health check for HTTP
resource "google_compute_health_check" "http" {
  name    = local.hc_name
  project = var.project_id

  http_health_check {
    port         = var.app_port
    request_path = "/"
  }

  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
}

# Managed Instance Group (zonal)
resource "google_compute_instance_group_manager" "mig" {
  name               = local.igm_name
  project            = var.project_id
  base_instance_name = var.name_prefix
  zone               = var.zone

  version {
    instance_template = google_compute_instance_template.tmpl.self_link
    name              = "primary"
  }

  target_size = var.instance_count

  named_port {
    name = local.port_name
    port = var.app_port
  }
}

# Backend service attaches the MIG
resource "google_compute_backend_service" "backend" {
  name                  = local.backend_name
  project               = var.project_id
  protocol              = "HTTP"
  port_name             = local.port_name
  timeout_sec           = 30
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [google_compute_health_check.http.self_link]

  backend {
    group = google_compute_instance_group_manager.mig.instance_group
  }
}

# URL map, target proxy, and global forwarding rule (HTTP:80)
resource "google_compute_url_map" "urlmap" {
  name     = local.url_map_name
  project  = var.project_id
  default_service = google_compute_backend_service.backend.self_link
}

resource "google_compute_target_http_proxy" "proxy" {
  name    = local.proxy_name
  project = var.project_id
  url_map = google_compute_url_map.urlmap.self_link
}

resource "google_compute_global_forwarding_rule" "http_fr" {
  name        = local.fr_name
  project     = var.project_id
  target      = google_compute_target_http_proxy.proxy.self_link
  port_range  = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_protocol = "TCP"
}
