#!/bin/bash
set -euo pipefail

# Notes:
# - Billing must be activated for the project
# - Post install "terraform init" must be executed to configure against the remote state in GCS


# TODO: Create an uninstall script to remove these resources that are not managed via Terraform
# TODO: Make script idemopotent so it can be re-run without error
export TF_VAR_PROJ_ID="${TF_VAR_PROJ_ID:-raspbernetes}"
export TF_VAR_PROJ_ID=${TF_VAR_PROJ_ID}
export TF_CREDS=~/.config/gcloud/${TF_VAR_PROJ_ID}-terraform-admin.json

# Create the service account in the Terraform admin project and download the JSON credentials
gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create "${TF_CREDS}" \
  --iam-account "terraform@${TF_VAR_PROJ_ID}.iam.gserviceaccount.com"

# Grant the service account permission to view the Admin Project and manage Cloud Storage
gcloud projects add-iam-policy-binding "${TF_VAR_PROJ_ID}" \
  --member "serviceAccount:terraform@${TF_VAR_PROJ_ID}.iam.gserviceaccount.com" \
  --role roles/viewer

gcloud projects add-iam-policy-binding "${TF_VAR_PROJ_ID}" \
  --member "serviceAccount:terraform@${TF_VAR_PROJ_ID}.iam.gserviceaccount.com" \
  --role roles/storage.admin

# Any actions that Terraform performs require that the API be enabled to do so
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable serviceusage.googleapis.com

# Create the remote backend bucket in Cloud Storage and the backend.tf file for storage of the terraform.tfstate file
gsutil mb -p "${TF_VAR_PROJ_ID}" "gs://${TF_VAR_PROJ_ID}-terraform-state"

# TODO: Make sure backend.tf is located under the infrastructure/ directory
cat > backend.tf << EOF
terraform {
  backend "gcs" {
    bucket  = "${TF_VAR_PROJ_ID}-terraform-state"
    prefix  = "terraform/state"
  }
}
EOF

# Enable versioning for the remote bucket
gsutil versioning set on "gs://${TF_VAR_PROJ_ID}-terraform-state"

# Configure your environment for the Google Cloud Terraform provider
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_VAR_PROJ_ID}

