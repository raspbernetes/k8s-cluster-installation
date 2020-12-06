terraform {
  backend "gcs" {
    bucket = "raspbernetes-terraform-state"
    prefix = "terraform/state"
  }
}
