
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for load balancer and resources"
  type        = string
}

variable "zone" {
  description = "Zone for the instance group"
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

variable "network" {
  description = "Self-link of the VPC network"
  type        = string
}

variable "subnetwork" {
  description = "Self-link of the subnetwork"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "priv-nginx"
}

variable "machine_type" {
  description = "Machine type for instances"
  type        = string
 
}

variable "instance_count" {
  description = "Number of instances in the MIG"
  type        = number

}

variable "app_port" {
  description = "Application port (Nginx HTTP port)"
  type        = number
  default     = 80
}

variable "tags" {
  description = "Network tags applied to instances (include lb-backend, ssh-iap)"
  type        = list(string)
  
}

variable "service_account_email" {
  description = "Service account for instances (optional)"
  type        = string
  default     = null
}

variable "startup_script" {
  description = "Custom startup script (optional). If not provided, a default installs Nginx."
  type        = string
  default     = null
}
