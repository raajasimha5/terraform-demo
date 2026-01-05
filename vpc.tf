resource "google_compute_network" "custom_vpc" {
  project                 = var.gcp_project_id
  name                    = "my-demo-vpc"
  auto_create_subnetworks = true
}

output "vpc_network_name" {
  description = "The name of the custom VPC network."
  value       = google_compute_network.custom_vpc.name
}