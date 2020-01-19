# Terraform CodeBuild Lambda Deployment Pipeline Role Module Example

## Getting Started

To use the example project for module testing, clone the repository, navigate to the examples folder and initialize the terraform project with the `terraform init` command. Once the project has initialized, be sure to change any variable values in the env.tfvars file, and then execute the `terraform plan -var-file=env.tfvars` command in order to run the module against your AWS account.

> __Note:__ AWS credentials will need to be set up prior to attempting to run this example project. Terraform uses the same authentication as the awscli. If your credentials are already configured to use the AWS CLI then terraform should be ready to use with this module.
