
output "instance_group" {
  description = "Instance group URI"
  value       = google_compute_instance_group_manager.mig.instance_group
}

output "lb_ip_address" {
  description = "Global forwarding rule IP address"
  value       = google_compute_global_forwarding_rule.http_fr.ip_address
}

output "lb_url" {
  description = "HTTP URL to reach the load balancer"
  value       = "http://${google_compute_global_forwarding_rule.http_fr.ip_address}"
}
