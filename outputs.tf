
output "lb_ip_address" {
  value       = module.private_vm_http_lb.lb_ip_address
  description = "External HTTP LB IP"
}

output "lb_url" {
  value       = module.private_vm_http_lb.lb_url
  description = "HTTP URL to reach Nginx via the Load Balancer"
}

output "instance_group" {
  value       = module.private_vm_http_lb.instance_group
  description = "MIG instance group URI"
}
