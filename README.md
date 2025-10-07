# dg-scoreboard-infrastructure
Terraform infrastructure setup for Disk Golf Scoreboard app

## Run in dev
```
terraform init -reconfigure -backend-config=./backends/dev_backend.config
terraform plan -var-file=./envs/dev.tfvars -out=tfplan
terraform apply "tfplan"
```