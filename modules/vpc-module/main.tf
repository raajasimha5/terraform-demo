resource "google_compute_network" "custom_vpc" {
  project                 = var.gcp_project_id
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
  }

