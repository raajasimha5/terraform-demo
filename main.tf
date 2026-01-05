terraform {
  backend "gcs" {
    bucket = "tf-rsv-demo"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}


