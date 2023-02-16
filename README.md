# aws-infra

Terraform script to create following resources
1. VPCs
2. 3 Subnets for private and public each
3. Public route table
4. Private route table
5. Internet Gateway for public router

Steps to run script

1. Initialize terraform state by running init command
terraform init

2. Check plan by running plan command
terraform plan

3. Create resources by apply command
terraform apply

4. Destroy resources after use by destroy command
terraform destroy


Input parameters while creating resources
1. Enter region name (eg: us-east-1, us-west-1)

2. Enter profile name (eg dev, demo)

3. Enter VPC resource name