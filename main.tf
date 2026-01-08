
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Enable Compute API (recommended)
resource "google_project_service" "compute" {
  project                    = var.project_id
  service                    = "compute.googleapis.com"
  disable_dependent_services = false
}

# Data sources for Google-managed IP blocks
data "google_netblock_ip_ranges" "health_checkers" {
  range_type = "health-checkers"
}

data "google_netblock_ip_ranges" "iap_forwarders" {
  range_type = "iap-forwarders"
}

# Data source for legacy health checkers, also used by external LBs for traffic
data "google_netblock_ip_ranges" "legacy_health_checkers" {
  range_type = "legacy-health-checkers"
}

# ---------------------------
# Network + Subnet
# ---------------------------

resource "google_compute_network" "vpc" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false

  depends_on = [google_project_service.compute]
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.network_name}-subnet"
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true
}

# ---------------------------
# Cloud Router + NAT
# ---------------------------

resource "google_compute_router" "router" {
  name    = var.router_name
  region  = var.region
  network = google_compute_network.vpc.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = var.nat_name
  region                             = var.region
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# ---------------------------
# Firewalls (INGRESS)
# ---------------------------

# Allow HTTP traffic from Google Front Ends (GFE) + health-check probers to backends
resource "google_compute_firewall" "allow_lb_http" {
  name    = "${var.name_prefix}-allow-lb-http"
  project = var.project_id
  network = google_compute_network.vpc.self_link

  direction     = "INGRESS"
  priority      = 1000
  source_ranges = data.google_netblock_ip_ranges.health_checkers.cidr_blocks_ipv4
  
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["lb-backend"]
}

# Allow SSH via IAP to private VMs (no public IP)
resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "${var.name_prefix}-allow-iap-ssh"
  project = var.project_id
  network = google_compute_network.vpc.self_link

  direction     = "INGRESS"
  priority      = 1000
  source_ranges = data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["ssh-iap"]
}

# ---------------------------
# Module: Private VM + External HTTP LB
# ---------------------------

module "private_vm_http_lb" {
  source     = "./private_vm_http_lb modules"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
  image_family = var.image_family
  image_project = var.image_project

  network    = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.subnet.self_link

  name_prefix    = var.name_prefix
  machine_type   = var.machine_type
  instance_count = var.instance_count
  app_port       = 80
  tags           = var.vm_tags

  # Optional: custom startup script to replace default nginx install
  # startup_script = file("${path.module}/startup.sh")
}
