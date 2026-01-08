terraform {
    backend "gcs" {
        bucket = "tf-rsv-demo"
        prefix = "terraform/state1"
    }
}
