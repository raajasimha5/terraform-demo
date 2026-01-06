output "instance_names" {
  description = "The names of the created VM instances."
  value       = module.compute.instance_names
}

output "instance_external_ips" {
  description = "The external IP addresses of the created VM instances."
  value       = module.compute.instance_external_ips
}

output "vpc_network_name" {
  description = "The name of the custom VPC network."
  value       = module.vpc.vpc_network_name
  }

