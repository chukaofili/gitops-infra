# gitops-infra

1. Add service account (create on from google cloud console) and base64 encode
2. Create terraform.auto.tfvars file from terraform.auto.tfvars.example file and update variables (* defaults => region: europe-west1, zone: europe-west1-d)
3. `cd terraform`
4. `terraform init`
5. `terraform apply`