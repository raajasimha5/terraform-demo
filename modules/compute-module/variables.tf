variable "gcp_project_id" {
  description = "The GCP project ID to deploy resources into."
  type        = string
}

variable "gcp_region" {
  description = "The GCP region for the resources."
  type        = string
}

variable "gcp_zone" {
  description = "The GCP zone for the VM instance."
  type        = string
 }

variable "vm_instance_count" {
  description = "The number of VM instances to create."
  type        = number
  }

variable "vm_instance_name" {
  description = "The base name for the VM instances."
  type        = string
 }

variable "vm_machine_type" {
  description = "The machine type for the VM."
  type        = string
  }

variable "vm_image" {
  description = "The boot disk image for the VM."
  type        = string
  }

variable "network_name" {
  description = "The name of the VPC network to attach the VM to."
  type        = string
}
