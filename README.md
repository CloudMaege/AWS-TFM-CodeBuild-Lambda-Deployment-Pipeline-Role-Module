<!-- markdownlint-disable MD024 -->
<!-- markdownlint-disable MD025 -->
<!-- markdownlint-disable MD028 -->

# Terraform Lambda Deployment Pipeline CodeBuild Role Module

![Hero](images/tf_iam.png)

<br>

# Getting Started

This AWS IAM Role module is designed to produce a CodeBuild IAM role that will be applied to the Lambda Deployment Pipeline CodeBuild Job. The Lambda Deployment Pipeline will have the ability to optionally pull and put Lambda packages on S3, Send SNS Topic notifications and build and deploy Lambda functions in a CI/CD pipeline, allowing code update on-demand or via webhook triggers. This role will give the required permissions to necessary EC2 resources that CodeBuild needs to operate within a VPC, access to CloudWatch Logging, Lambda, and STS PassRole. It will also optionally assign permissions to S3 buckets, SNS Topics and KMS CMKs provided the corresponding variables are supplied to the module.

<br><br>

## Module Pre-Requisites

No Pre-Requisites Defined.

<br><br>

## Module usage in project root main.tf

```terraform
module "lambda_codebuild_deployment_pipeline_role" {
  source = "git@github.com:CloudMage-TF/TF-AWS-Lambda-Deploy-CodeBuild-Role-Module.git?ref=v1.0.2"

  // Optional
  lambda_role_name                  = "Codebuild Role Name"
  lambda_role_description           = "CodeBuild Role Description"
  lambda_pipeline_s3_resource_list  = []
  lambda_pipeline_sns_resource_list = []
  lambda_pipeline_cmk_resource_list = []
}
```

<br><br>

## Variables

The following variables are utilized by this module and cause the module to behave dynamically based upon the variables that are populated and passed into the module.

<br><br>

## :large_blue_circle: lambda_role_name

<br>

![Optional](images/neon_optional.png)

<br>

This variable can be used to customize the name of the Lambda CodeBuild Deployment Role that will be provisioned. If this value is not defined, then the CodeBuild Role name will be set to `CodeBuild-Lambda-Pipeline-Service-Role`.

<br><br>

### Declaration in module variables.tf

```terraform
variable "lambda_role_name" {
  type        = string
  description = "Specify a name for the the Lambda Pipeline Service Role."
  default     = "CodeBuild-Lambda-Pipeline-Service-Role"
}
```

<br><br>

### Module usage in project root main.tf

```terraform
module "lambda_codebuild_deployment_pipeline_role" {
  source = "git@github.com:CloudMage-TF/TF-AWS-Lambda-Deploy-CodeBuild-Role-Module.git?ref=v1.0.2"

  // Optional
  lambda_role_name  = "Company-CodeBuild-Lambda-Deployment-Role"
}
```

<br><br><br>

## :large_blue_circle: lambda_role_description

<br>

![Optional](images/neon_optional.png)

<br>

This variable can be used to customize the description of the Lambda CodeBuild Deployment Role that will be provisioned. If this value is not defined, then the CodeBuild Role description will be set to `Specify the description for the the Lambda Pipeline Service Role.`.

<br><br>

### Declaration in module variables.tf

```terraform
variable "lambda_role_description" {
  type        = string
  description = "Specify the description for the the Lambda Pipeline Service Role."
  default     = "CodeBuild Role that allows CodeBuild to deploy Lambda Functions."
}
```

<br><br>

### Module usage in project root main.tf

```terraform
module "lambda_codebuild_deployment_pipeline_role" {
  source = "git@github.com:CloudMage-TF/TF-AWS-Lambda-Deploy-CodeBuild-Role-Module.git?ref=v1.0.2"

  // Optional
  lambda_role_name        = "Company-CodeBuild-Lambda-Deployment-Role"
  lambda_role_description = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
}
```

<br><br><br>

## :large_blue_circle: lambda_pipeline_s3_resource_list

<br>

![Optional](images/neon_optional.png)

<br>

This variable can contain a list of AWS S3 Bucket ARNs that the CodeBuild Role will be given **CRUD** access to. For each bucket ARN provided, the module will create an IAM policy document that will automatically contain a wildcard entry along with the original bucket ARN. `["arn:aws:s3:::bucket", "arn:aws:s3:::bucket/*"]`

<br><br>

### Declaration in module variables.tf

```terraform
variable "lambda_pipeline_s3_resource_list" {
  type        = list(string)
  description = "List of S3 Bucket ARNs that the CodeBuild Lambda Pipeline Service Role will be given access to."
  default     = []
}
```

<br><br>

### Module usage in project root main.tf

```terraform
module "lambda_codebuild_deployment_pipeline_role" {
  source = "git@github.com:CloudMage-TF/TF-AWS-Lambda-Deploy-CodeBuild-Role-Module.git?ref=v1.0.2"

  // Optional
  lambda_role_name        = "Company-CodeBuild-Lambda-Deployment-Role"
  lambda_role_description = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
  
  lambda_pipeline_s3_resource_list = ["arn:aws:s3:::kms-encrypted-demo-bucket"]
}
```

<br><br><br>

## :large_blue_circle: lambda_pipeline_sns_resource_list

<br>

![Optional](images/neon_optional.png)

<br>

This variable can contain a list of AWS SNS Topic ARNs that the CodeBuild Role will be given **Publish** access to allow event notification alerting.

<br><br>

### Declaration in module variables.tf

```terraform
variable "lambda_pipeline_sns_resource_list" {
  type        = list(string)
  description = "List of SNS Topic ARNs that the CodeBuild Lambda Pipeline Service Role will be given access to."
  default     = []
}
```

<br><br>

### Module usage in project root main.tf

```terraform
module "lambda_codebuild_deployment_pipeline_role" {
  source = "git@github.com:CloudMage-TF/TF-AWS-Lambda-Deploy-CodeBuild-Role-Module.git?ref=v1.0.2"

  // Optional
  lambda_role_name        = "Company-CodeBuild-Lambda-Deployment-Role"
  lambda_role_description = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
  lambda_pipeline_sns_resource_list = ["arn:aws:sns:::CodeBuild-Notification-Topic"]
  
  // lambda_pipeline_s3_resource_list  = ["arn:aws:s3:::kms-encrypted-demo-bucket"]
}
```

<br><br><br>

## :large_blue_circle: lambda_pipeline_cmk_resource_list

<br>

![Optional](images/neon_optional.png)

<br>

This variable can contain a list of AWS KMS CMK ARNs that the CodeBuild Role will be given usage access to so that it can be allowed to encrypt/decrypt objects stored in an encrypted S3 bucket.

<br><br>

### Declaration in module variables.tf

```terraform
variable "lambda_pipeline_cmk_resource_list" {
  type        = list(string)
  description = "Optional - List of KMS CMK ARNs that the CodeBuild Lambda Pipeline Service Role will be given usage permissions to."
  default     = []
}
```

<br><br>

### Module usage in project root main.tf

```terraform
module "lambda_codebuild_deployment_pipeline_role" {
  source = "git@github.com:CloudMage-TF/TF-AWS-Lambda-Deploy-CodeBuild-Role-Module.git?ref=v1.0.2"

  // Optional
  lambda_role_name        = "Company-CodeBuild-Lambda-Deployment-Role"
  lambda_role_description = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
  lambda_pipeline_s3_resource_list  = ["arn:aws:s3:::kms-encrypted-demo-bucket"]
  lambda_pipeline_cmk_resource_list = ["arn:aws:kms:us-west-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"]
  
  // lambda_pipeline_sns_resource_list = ["arn:aws:sns:::CodeBuild-Notification-Topic"]
}
```

<br><br>

# Module Example Usage

An example of how to use this module can be found within the `example` directory of this repository

<br><br>

# Module Outputs

The template will finally create the following outputs that can be pulled and used in subsequent terraform runs via data sources. The outputs will be written to the terraform state file.

<br>

```terraform
######################
# S3 Bucket:         #
######################
output "codebuild_role_arn" {}
output "codebuild_role_id" {}
```

<br><br>

# Dependencies

This module does not currently have any dependencies

<br><br>

# Requirements

* [Terraform](https://www.terraform.io/)
* [GIT](https://git-scm.com/download/win)
* [AWS-Account](https://https://aws.amazon.com/)

<br><br>

# Recommended

* [Terraform for VSCode](https://github.com/mauve/vscode-terraform)
* [Terraform Config Inspect](https://github.com/hashicorp/terraform-config-inspect)

<br><br>

## Contributions and Contacts

This project is owned by [CloudMage](rnason@cloudmage.io).

To contribute, please:

* Fork the project
* Create a local branch
* Submit Changes
* Create A Pull Request
