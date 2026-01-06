variable "auto_create_subnetworks" {
  description = "When set to true, the network is created in 'auto subnet mode'. When set to false, the network is created in 'custom subnet mode'."
  type        = bool
 }

variable "vpc_name" {
  description = "The name of the VPC network."
  type        = string
}

 variable "gcp_project_id" {
  description = "The GCP project ID to deploy resources into."
  type        = string
}

