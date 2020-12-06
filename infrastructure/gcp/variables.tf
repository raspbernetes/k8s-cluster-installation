variable "project_id" {
  description = "The GCP project ID that resources will be created in"
  default     = "raspbernetes"
}

variable "region" {
  description = "The GCP region that resources will be created in"
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The GKE cluster name"
  default     = "raspbernetes-gke"
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}
