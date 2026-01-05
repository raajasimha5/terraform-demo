output "instance_names" {
  description = "The names of the created VM instances."
  value       = google_compute_instance.default.*.name
}

output "instance_external_ips" {
  description = "The external IP addresses of the created VM instances."
  value       = google_compute_instance.default.*.network_interface.0.access_config.0.nat_ip
}