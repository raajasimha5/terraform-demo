
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for resources"
  type        = string
}

variable "zone" {
  description = "Zone for resources"
  type        = string
}

variable "image_family" {
  description = "The image family to use for the VM template (e.g., debian-12, ubuntu-2004-lts)"
  type        = string
  }
 
variable "image_project" {
  description = "The GCP project where the image family exists (e.g., debian-cloud, ubuntu-os-cloud)"
  type        = string
 }

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
}

variable "router_name" {
  description = "Name for the Cloud Router"
  type        = string
}

variable "nat_name" {
  description = "Name for the Cloud NAT gateway"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "machine_type" {
  description = "Machine type for instances"
  type        = string
}

variable "instance_count" {
  description = "Number of instances in the MIG"
  type        = number
}

# Tags to apply to VM instances (used by firewall target_tags)
# Keep "lb-backend" for HTTP LB traffic and "ssh-iap" for IAP SSH.
variable "vm_tags" {
  description = "Network tags applied to instances"
  type        = list(string)
}
