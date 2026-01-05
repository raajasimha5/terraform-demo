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

resource "google_storage_bucket" "tf_state" {
  # Use the variable to ensure the bucket name is consistent
  name = var.tf_state_bucket_name

  # Use the region variable for resource location
  location = var.gcp_region

  uniform_bucket_level_access = true

  # Adding a label as a small change to test state file versioning.
  labels = {
    purpose = "terraform-state-bucket"
  }

  # Enable versioning to keep a history of your state files.
  # This is critical for preventing accidental data loss or corruption.
  versioning {
    enabled = true
  }

  # This lifecycle block prevents Terraform from accidentally deleting
  # the state bucket, which is a critical piece of your infrastructure.
  lifecycle {
    prevent_destroy = true
  }
}

output "state_bucket_name" {
  description = "The name of the GCS bucket storing Terraform state."
  value       = google_storage_bucket.tf_state.name
}
