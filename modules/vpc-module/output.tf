
output "vpc_network_name" {
  description = "The name of the custom VPC network."
  value       = google_compute_network.custom_vpc.name
}