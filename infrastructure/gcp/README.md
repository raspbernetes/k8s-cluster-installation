#

## Initialize Terraform workspace and provision GKE Cluster

Replace `terraform.tfvars` values with your `project_id` and `region`. Your
`project_id` must match the project you've initialized gcloud with. To change your
`gcloud` settings, run `gcloud init`. The region has been defaulted to `us-central1`;
you can find a full list of gcloud regions [here](https://cloud.google.com/compute/docs/regions-zones).

After you've done this, initalize your Terraform workspace, which will download
the provider and initialize it with the values provided in the `terraform.tfvars` file.

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "google" (hashicorp/google) 3.13.0...
Terraform has been successfully initialized!
```

Then, provision your GKE cluster by running `terraform apply`.

```bash
$ terraform apply

# Output truncated...

Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

# Output truncated...

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

kubernetes_cluster_name = dos-terraform-edu-gke
region = us-central1
```

## Configure kubectl

Configure kubetcl, by running the following command:

```bash
gcloud container clusters get-credentials dos-terraform-edu-gke --region us-central1
```

The [Kubernetes Cluster Name](https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/master/gke.tf#L63) and [Region](https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/master/vpc.tf#L29) correspond to the resources spun up by Terraform.
