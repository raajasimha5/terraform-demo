resource "google_sourcerepo_repository" "my-repo" {
  name = "terrafrom-demo"
project = "smiling-breaker-325908"
}
resource "google_project_iam _member" "terraform_sa_compute"{
project = "smiling-breaker-325908"
role    = "roles/compute.admin"
member  = "serviceAcount:${google_service_account.terraform_sa.email}"
}
