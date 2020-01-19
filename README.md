<!-- markdownlint-disable MD024 -->
<!-- markdownlint-disable MD025 -->
<!-- markdownlint-disable MD028 -->
<!-- markdownlint-disable MD036 -->

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
  codebuild_role_name               = "Codebuild-Lambda-Role"
  codebuild_role_description        = "CodeBuild Role Description would go here"
  lambda_pipeline_s3_resource_list  = ["arn:aws:s3:::kms-encrypted-demo-bucket", "arn:aws:s3:::demo-lambda-deploy-bucket"]
  lambda_pipeline_sns_resource_list = ["arn:aws:sns:::CodeBuild-Notification-Topic"]
  lambda_pipeline_cmk_resource_list = ["arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"]
}
```

<br><br>

## Variables

The following variables are utilized by this module and cause the module to behave dynamically based upon the variables that are populated and passed into the module.

<br><br>

## :large_blue_circle: codebuild_role_name

<br>

![Optional](images/neon_optional.png)

<br>

This variable can be used to customize the name of the Lambda CodeBuild Deployment Role that will be provisioned. If this value is not defined, then the CodeBuild Role name will be set to `CodeBuild-Lambda-Pipeline-Service-Role`.

<br><br>

### Declaration in module variables.tf

```terraform
variable "codebuild_role_name" {
  type        = string
  description = "Specify a name for the the Lambda Pipeline Service Role."
  default     = "CodeBuild-Lambda-Pipeline-Service-Role"
}
```

<br><br>

### Module usage in project root main.tf default role name

```terraform
module "lambda_codebuild_deployment_pipeline_role" {
  source = "git@github.com:CloudMage-TF/TF-AWS-Lambda-Deploy-CodeBuild-Role-Module.git?ref=v1.0.2"

  # Optional
  // codebuild_role_name               = var.codebuild_role_name
  // codebuild_role_description        = var.codebuild_role_description
  // lambda_pipeline_s3_resource_list  = var.lambda_pipeline_s3_resource_list
  // lambda_pipeline_sns_resource_list = var.lambda_pipeline_sns_resource_list
  // lambda_pipeline_cmk_resource_list = var.lambda_pipeline_cmk_resource_list
}
```

<br><br>

### Example `terraform plan` output

```terraform
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

module.demo_codebuild_role.data.aws_caller_identity.current: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.principal_policy: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.access_policy: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.demo_codebuild_role.aws_iam_role.this will be created
  + resource "aws_iam_role" "this" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "codebuild.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + description           = "CodeBuild Role that allows CodeBuild to deploy Lambda Functions."
      + force_detach_policies = false
      + id                    = (known after apply)
      + max_session_duration  = 14400
      + name                  = "CodeBuild-Lambda-Pipeline-Service-Role"
      + path                  = "/"
      + unique_id             = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.access_policy will be created
  + resource "aws_iam_role_policy" "access_policy" {
      + id     = (known after apply)
      + name   = "CodeBuild-Lambda-Pipeline-Service-Role-AccessPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "logs:PutLogEvents",
                          + "logs:CreateLogStream",
                          + "logs:CreateLogGroup",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLogAccess"
                    },
                  + {
                      + Action   = [
                          + "ec2:DescribeVpcs",
                          + "ec2:DescribeSubnets",
                          + "ec2:DescribeSecurityGroups",
                          + "ec2:DescribeNetworkInterfaces",
                          + "ec2:DescribeDhcpOptions",
                          + "ec2:DeleteNetworkInterface",
                          + "ec2:CreateNetworkInterfacePermission",
                          + "ec2:CreateNetworkInterface",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineEC2Access"
                    },
                  + {
                      + Action   = "lambda:*"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLambdaAccess"
                    },
                  + {
                      + Action   = "iam:PassRole"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelinePassRole"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

<br><br>

### Module usage in project root main.tf custom role name

```terraform
module "lambda_codebuild_deployment_pipeline_role" {
  source = "git@github.com:CloudMage-TF/TF-AWS-Lambda-Deploy-CodeBuild-Role-Module.git?ref=v1.0.2"

  codebuild_role_name               = "CodeBuild-Lambda-Deploy-Role"

  # Optional
  // codebuild_role_description        = var.codebuild_role_description
  // lambda_pipeline_s3_resource_list  = var.lambda_pipeline_s3_resource_list
  // lambda_pipeline_sns_resource_list = var.lambda_pipeline_sns_resource_list
  // lambda_pipeline_cmk_resource_list = var.lambda_pipeline_cmk_resource_list
}
```

<br><br>

### Example `terraform plan` output

```terraform
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

module.demo_codebuild_role.data.aws_caller_identity.current: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.principal_policy: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.access_policy: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.demo_codebuild_role.aws_iam_role.this will be created
  + resource "aws_iam_role" "this" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "codebuild.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + description           = "CodeBuild Role that allows CodeBuild to deploy Lambda Functions."
      + force_detach_policies = false
      + id                    = (known after apply)
      + max_session_duration  = 14400
      + name                  = "CodeBuild-Lambda-Deploy-Role"
      + path                  = "/"
      + unique_id             = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.access_policy will be created
  + resource "aws_iam_role_policy" "access_policy" {
      + id     = (known after apply)
      + name   = "CodeBuild-Lambda-Deploy-Role-AccessPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "logs:PutLogEvents",
                          + "logs:CreateLogStream",
                          + "logs:CreateLogGroup",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLogAccess"
                    },
                  + {
                      + Action   = [
                          + "ec2:DescribeVpcs",
                          + "ec2:DescribeSubnets",
                          + "ec2:DescribeSecurityGroups",
                          + "ec2:DescribeNetworkInterfaces",
                          + "ec2:DescribeDhcpOptions",
                          + "ec2:DeleteNetworkInterface",
                          + "ec2:CreateNetworkInterfacePermission",
                          + "ec2:CreateNetworkInterface",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineEC2Access"
                    },
                  + {
                      + Action   = "lambda:*"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLambdaAccess"
                    },
                  + {
                      + Action   = "iam:PassRole"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelinePassRole"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

<br><br><br>

## :large_blue_circle: codebuild_role_description

<br>

![Optional](images/neon_optional.png)

<br>

This variable can be used to customize the description of the Lambda CodeBuild Deployment Role that will be provisioned. If this value is not defined, then the CodeBuild Role description will be set to `Specify the description for the the Lambda Pipeline Service Role.`.

<br><br>

### Declaration in module variables.tf

```terraform
variable "codebuild_role_description" {
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

  codebuild_role_name        = "CloudMage-CodeBuild-Lambda-Deployment-Role"
  codebuild_role_description = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."

  # Optional
  // lambda_pipeline_s3_resource_list  = var.lambda_pipeline_s3_resource_list
  // lambda_pipeline_sns_resource_list = var.lambda_pipeline_sns_resource_list
  // lambda_pipeline_cmk_resource_list = var.lambda_pipeline_cmk_resource_list
}
```

<br><br>

### Example `terraform plan` output

```terraform
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

module.demo_codebuild_role.data.aws_caller_identity.current: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.principal_policy: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.access_policy: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.demo_codebuild_role.aws_iam_role.this will be created
  + resource "aws_iam_role" "this" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "codebuild.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + description           = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
      + force_detach_policies = false
      + id                    = (known after apply)
      + max_session_duration  = 14400
      + name                  = "CloudMage-CodeBuild-Lambda-Deployment-Role"
      + path                  = "/"
      + unique_id             = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.access_policy will be created
  + resource "aws_iam_role_policy" "access_policy" {
      + id     = (known after apply)
      + name   = "CloudMage-CodeBuild-Lambda-Deployment-Role-AccessPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "logs:PutLogEvents",
                          + "logs:CreateLogStream",
                          + "logs:CreateLogGroup",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLogAccess"
                    },
                  + {
                      + Action   = [
                          + "ec2:DescribeVpcs",
                          + "ec2:DescribeSubnets",
                          + "ec2:DescribeSecurityGroups",
                          + "ec2:DescribeNetworkInterfaces",
                          + "ec2:DescribeDhcpOptions",
                          + "ec2:DeleteNetworkInterface",
                          + "ec2:CreateNetworkInterfacePermission",
                          + "ec2:CreateNetworkInterface",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineEC2Access"
                    },
                  + {
                      + Action   = "lambda:*"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLambdaAccess"
                    },
                  + {
                      + Action   = "iam:PassRole"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelinePassRole"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
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

  codebuild_role_name               = "CloudMage-CodeBuild-Lambda-Deployment-Role"
  codebuild_role_description        = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
  lambda_pipeline_s3_resource_list  = ["arn:aws:s3:::kms-encrypted-demo-bucket", "arn:aws:s3:::demo-lambda-deploy-bucket"]

  # Optional
  // lambda_pipeline_sns_resource_list = var.lambda_pipeline_sns_resource_list
  // lambda_pipeline_cmk_resource_list = var.lambda_pipeline_cmk_resource_list
}
```

<br><br>

### Generated IAM S3 Access Policy

```yaml
Statement:
  - Sid: "LambdaPipelineS3Access"
    Effect: Allow
    Action:
      - "s3:PutObjectVersionTagging"
      - "s3:PutObjectTagging"
      - "s3:PutObject"
      - "s3:ListBucket"
      - "s3:GetObjectVersion"
      - "s3:GetObject"
      - "s3:GetBucketLocation"
      - "s3:GetBucketAcl"
      - "s3:DeleteObject"
    Resources:
      - "arn:aws:s3:::kms-encrypted-demo-bucket"
      - "arn:aws:s3:::kms-encrypted-demo-bucket/*"
      - "arn:aws:s3:::demo-lambda-deploy-bucket"
      - "arn:aws:s3:::demo-lambda-deploy-bucket/*"
```

<br><br>

### Example `terraform plan` output

```terraform
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

module.demo_codebuild_role.data.aws_caller_identity.current: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.principal_policy: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.access_policy: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.s3_policy[0]: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.demo_codebuild_role.aws_iam_role.this will be created
  + resource "aws_iam_role" "this" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "codebuild.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + description           = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
      + force_detach_policies = false
      + id                    = (known after apply)
      + max_session_duration  = 14400
      + name                  = "CloudMage-CodeBuild-Lambda-Deployment-Role"
      + path                  = "/"
      + unique_id             = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.access_policy will be created
  + resource "aws_iam_role_policy" "access_policy" {
      + id     = (known after apply)
      + name   = "CloudMage-CodeBuild-Lambda-Deployment-Role-AccessPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "logs:PutLogEvents",
                          + "logs:CreateLogStream",
                          + "logs:CreateLogGroup",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLogAccess"
                    },
                  + {
                      + Action   = [
                          + "ec2:DescribeVpcs",
                          + "ec2:DescribeSubnets",
                          + "ec2:DescribeSecurityGroups",
                          + "ec2:DescribeNetworkInterfaces",
                          + "ec2:DescribeDhcpOptions",
                          + "ec2:DeleteNetworkInterface",
                          + "ec2:CreateNetworkInterfacePermission",
                          + "ec2:CreateNetworkInterface",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineEC2Access"
                    },
                  + {
                      + Action   = "lambda:*"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLambdaAccess"
                    },
                  + {
                      + Action   = "iam:PassRole"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelinePassRole"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.s3_policy[0] will be created
  + resource "aws_iam_role_policy" "s3_policy" {
      + id     = (known after apply)
      + name   = "CloudMage-CodeBuild-Lambda-Deployment-Role-S3Policy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "s3:PutObjectVersionTagging",
                          + "s3:PutObjectTagging",
                          + "s3:PutObject",
                          + "s3:ListBucket",
                          + "s3:GetObjectVersion",
                          + "s3:GetObject",
                          + "s3:GetBucketLocation",
                          + "s3:GetBucketAcl",
                          + "s3:DeleteObject",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "arn:aws:s3:::kms-encrypted-demo-bucket/*",
                          + "arn:aws:s3:::kms-encrypted-demo-bucket",
                          + "arn:aws:s3:::demo-lambda-deploy-bucket/*",
                          + "arn:aws:s3:::demo-lambda-deploy-bucket",
                        ]
                      + Sid      = "LambdaPipelineS3Access"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
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

  codebuild_role_name               = "CloudMage-CodeBuild-Lambda-Deployment-Role"
  codebuild_role_description        = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
  lambda_pipeline_sns_resource_list = ["arn:aws:sns:::CodeBuild-Notification-Topic"]

  # Optional
  // lambda_pipeline_s3_resource_list = var.lambda_pipeline_s3_resource_list
  // lambda_pipeline_cmk_resource_list = var.lambda_pipeline_cmk_resource_list
}
```

<br><br>

### Generated IAM S3 Access Policy

```yaml
Statement:
  - Sid: "LambdaPipelineSNSAccess"
    Effect: Allow
    Action:
      - "sns:Publish"
    Resources:
      - "arn:aws:sns:::CodeBuild-Notification-Topic"
```

<br><br>

### Example `terraform plan` output

```terraform
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

module.demo_codebuild_role.data.aws_caller_identity.current: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.sns_policy[0]: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.principal_policy: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.access_policy: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.demo_codebuild_role.aws_iam_role.this will be created
  + resource "aws_iam_role" "this" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "codebuild.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + description           = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
      + force_detach_policies = false
      + id                    = (known after apply)
      + max_session_duration  = 14400
      + name                  = "CloudMage-CodeBuild-Lambda-Deployment-Role"
      + path                  = "/"
      + unique_id             = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.access_policy will be created
  + resource "aws_iam_role_policy" "access_policy" {
      + id     = (known after apply)
      + name   = "CloudMage-CodeBuild-Lambda-Deployment-Role-AccessPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "logs:PutLogEvents",
                          + "logs:CreateLogStream",
                          + "logs:CreateLogGroup",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLogAccess"
                    },
                  + {
                      + Action   = [
                          + "ec2:DescribeVpcs",
                          + "ec2:DescribeSubnets",
                          + "ec2:DescribeSecurityGroups",
                          + "ec2:DescribeNetworkInterfaces",
                          + "ec2:DescribeDhcpOptions",
                          + "ec2:DeleteNetworkInterface",
                          + "ec2:CreateNetworkInterfacePermission",
                          + "ec2:CreateNetworkInterface",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineEC2Access"
                    },
                  + {
                      + Action   = "lambda:*"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLambdaAccess"
                    },
                  + {
                      + Action   = "iam:PassRole"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelinePassRole"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.sns_policy[0] will be created
  + resource "aws_iam_role_policy" "sns_policy" {
      + id     = (known after apply)
      + name   = "CloudMage-CodeBuild-Lambda-Deployment-Role-SNSPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = "sns:Publish"
                      + Effect   = "Allow"
                      + Resource = "arn:aws:sns:::CodeBuild-Notification-Topic"
                      + Sid      = "LambdaPipelineSNSAccess"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
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

  codebuild_role_name               = "CloudMage-CodeBuild-Lambda-Deployment-Role"
  codebuild_role_description        = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
  lambda_pipeline_cmk_resource_list = ["arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"]

  # Optional
  // lambda_pipeline_s3_resource_list = var.lambda_pipeline_s3_resource_list
  // lambda_pipeline_sns_resource_list = var.lambda_pipeline_sns_resource_list
}
```

<br><br>

### Generated IAM S3 Access Policy

```yaml
Statement:
  - Sid: "LambdaPipelineCMKAccess"
    Effect: Allow
    Action:
      - "kms:DescribeKey"
      - "kms:Encrypt"
      - "kms:Decrypt"
      - "kms:ReEncrypt*"
      - "kms:GenerateDataKey*"
      - "kms:ListGrants"
      - "kms:CreateGrant"
      - "kms:RetireGrant"
      - "kms:RevokeGrant"
    Resources:
      - "arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
```

<br><br>

### Example `terraform plan` output

```terraform
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

module.demo_codebuild_role.data.aws_caller_identity.current: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.cmk_policy[0]: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.principal_policy: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.access_policy: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.demo_codebuild_role.aws_iam_role.this will be created
  + resource "aws_iam_role" "this" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "codebuild.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + description           = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
      + force_detach_policies = false
      + id                    = (known after apply)
      + max_session_duration  = 14400
      + name                  = "CloudMage-CodeBuild-Lambda-Deployment-Role"
      + path                  = "/"
      + unique_id             = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.access_policy will be created
  + resource "aws_iam_role_policy" "access_policy" {
      + id     = (known after apply)
      + name   = "CloudMage-CodeBuild-Lambda-Deployment-Role-AccessPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "logs:PutLogEvents",
                          + "logs:CreateLogStream",
                          + "logs:CreateLogGroup",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLogAccess"
                    },
                  + {
                      + Action   = [
                          + "ec2:DescribeVpcs",
                          + "ec2:DescribeSubnets",
                          + "ec2:DescribeSecurityGroups",
                          + "ec2:DescribeNetworkInterfaces",
                          + "ec2:DescribeDhcpOptions",
                          + "ec2:DeleteNetworkInterface",
                          + "ec2:CreateNetworkInterfacePermission",
                          + "ec2:CreateNetworkInterface",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineEC2Access"
                    },
                  + {
                      + Action   = "lambda:*"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLambdaAccess"
                    },
                  + {
                      + Action   = "iam:PassRole"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelinePassRole"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.cmk_policy[0] will be created
  + resource "aws_iam_role_policy" "cmk_policy" {
      + id     = (known after apply)
      + name   = "CloudMage-CodeBuild-Lambda-Deployment-Role-CMKPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "kms:RevokeGrant",
                          + "kms:RetireGrant",
                          + "kms:ReEncrypt*",
                          + "kms:ListGrants",
                          + "kms:GenerateDataKey*",
                          + "kms:Encrypt",
                          + "kms:DescribeKey",
                          + "kms:Decrypt",
                          + "kms:CreateGrant",
                        ]
                      + Effect   = "Allow"
                      + Resource = "arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
                      + Sid      = "LambdaPipelineCMKAccess"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

<br><br><br>

# Complete IAM CodeBuild Role Permissions

When all options have been provided, the complete IAM Role will be provisioned with the following permissions:

## Project main.tf

```terraform
module "lambda_codebuild_deployment_pipeline_role" {
  source = "git@github.com:CloudMage-TF/TF-AWS-Lambda-Deploy-CodeBuild-Role-Module.git?ref=v1.0.2"

  codebuild_role_name               = "CloudMage-CodeBuild-Lambda-Deployment-Role"
  codebuild_role_description        = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
  lambda_pipeline_s3_resource_list  = ["arn:aws:s3:::kms-encrypted-demo-bucket", "arn:aws:s3:::demo-lambda-deploy-bucket"]
  lambda_pipeline_sns_resource_list = ["arn:aws:sns:::CodeBuild-Notification-Topic"]
  lambda_pipeline_cmk_resource_list = ["arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"]
}
```

<br><br>

### Generated IAM S3 Access Policy

**arn:aws:iam::123456789101:policy/CloudMage-CodeBuild-Lambda-Deployment-Role-S3Policy**

```yaml
Statement:
  - Sid: "LambdaPipelineS3Access"
    Effect: Allow
    Action:
      - "s3:PutObjectVersionTagging"
      - "s3:PutObjectTagging"
      - "s3:PutObject"
      - "s3:ListBucket"
      - "s3:GetObjectVersion"
      - "s3:GetObject"
      - "s3:GetBucketLocation"
      - "s3:GetBucketAcl"
      - "s3:DeleteObject"
    Resources:
      - "arn:aws:s3:::kms-encrypted-demo-bucket"
      - "arn:aws:s3:::kms-encrypted-demo-bucket/*"
      - "arn:aws:s3:::demo-lambda-deploy-bucket"
      - "arn:aws:s3:::demo-lambda-deploy-bucket/*"
```

<br>

**arn:aws:iam::123456789101:policy/CloudMage-CodeBuild-Lambda-Deployment-Role-SNSPolicy**

```yaml
Statement:
  - Sid: "LambdaPipelineSNSAccess"
    Effect: Allow
    Action:
      - "sns:Publish"
    Resources:
      - "arn:aws:sns:::CodeBuild-Notification-Topic"
```

<br>

**arn:aws:iam::123456789101:policy/CloudMage-CodeBuild-Lambda-Deployment-Role-CMKPolicy**

```yaml
Statement:
  - Sid: "LambdaPipelineCMKAccess"
    Effect: Allow
    Action:
      - "kms:DescribeKey"
      - "kms:Encrypt"
      - "kms:Decrypt"
      - "kms:ReEncrypt*"
      - "kms:GenerateDataKey*"
      - "kms:ListGrants"
      - "kms:CreateGrant"
      - "kms:RetireGrant"
      - "kms:RevokeGrant"
    Resources:
      - "arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
```

<br>

**arn:aws:iam::123456789101:role/CloudMage-CodeBuild-Lambda-Deployment-Role**

```yaml
CloudMage-CodeBuild-Lambda-Deployment-Role:
  AssumeRolePolicyDocument:
    Version: '2012-10-17'
    Statement:
      - Effect: Allow
        Principal:
          Service:
            - codebuild.amazonaws.com
        Action: sts:AssumeRole
  Policies:
    - PolicyName: CloudMage-CodeBuild-Lambda-Deployment-Role-AccessPolicy
      PolicyDocument:
      Version: '2012-10-17'
      Statement:
        - Sid: LambdaPipelineLogAccess
          Effect: Allow
          Action:
            - logs:PutLogEvents
            - logs:CreateLogStream
            - logs:CreateLogGroup
          Resource: "*"
        - Sid: LambdaPipelineEC2Access
          Effect: Allow
          Action:
            - ec2:DescribeVpcs
            - ec2:DescribeSubnets
            - ec2:DescribeSecurityGroups
            - ec2:DescribeNetworkInterfaces
            - ec2:DescribeDhcpOptions
            - ec2:DeleteNetworkInterface
            - ec2:CreateNetworkInterfacePermission
            - ec2:CreateNetworkInterface
          Resource: "*"
        - Sid: LambdaPipelineLambdaAccess
          Effect: Allow
          Action:
            - lambda:*
          Resource: "*"
        - Sid: LambdaPipelinePassRole
          Effect: Allow
          Action:
            - iam:PassRole
          Resource: "*"
  ManagedPolicyArns:
    - "arn:aws:iam::123456789101:policy/CloudMage-CodeBuild-Lambda-Deployment-Role-S3Policy"
    - "arn:aws:iam::123456789101:policy/CloudMage-CodeBuild-Lambda-Deployment-Role-SNSPolicy"
    - "arn:aws:iam::123456789101:policy/CloudMage-CodeBuild-Lambda-Deployment-Role-CMKPolicy"
```

<br><br>

### Example `terraform plan` output

```terraform
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

module.demo_codebuild_role.data.aws_caller_identity.current: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.principal_policy: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.cmk_policy[0]: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.sns_policy[0]: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.s3_policy[0]: Refreshing state...
module.demo_codebuild_role.data.aws_iam_policy_document.access_policy: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.demo_codebuild_role.aws_iam_role.this will be created
  + resource "aws_iam_role" "this" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "codebuild.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + description           = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
      + force_detach_policies = false
      + id                    = (known after apply)
      + max_session_duration  = 14400
      + name                  = "CloudMage-CodeBuild-Lambda-Deployment-Role"
      + path                  = "/"
      + unique_id             = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.access_policy will be created
  + resource "aws_iam_role_policy" "access_policy" {
      + id     = (known after apply)
      + name   = "CloudMage-CodeBuild-Lambda-Deployment-Role-AccessPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "logs:PutLogEvents",
                          + "logs:CreateLogStream",
                          + "logs:CreateLogGroup",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLogAccess"
                    },
                  + {
                      + Action   = [
                          + "ec2:DescribeVpcs",
                          + "ec2:DescribeSubnets",
                          + "ec2:DescribeSecurityGroups",
                          + "ec2:DescribeNetworkInterfaces",
                          + "ec2:DescribeDhcpOptions",
                          + "ec2:DeleteNetworkInterface",
                          + "ec2:CreateNetworkInterfacePermission",
                          + "ec2:CreateNetworkInterface",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineEC2Access"
                    },
                  + {
                      + Action   = "lambda:*"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelineLambdaAccess"
                    },
                  + {
                      + Action   = "iam:PassRole"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "LambdaPipelinePassRole"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.cmk_policy[0] will be created
  + resource "aws_iam_role_policy" "cmk_policy" {
      + id     = (known after apply)
      + name   = "CloudMage-CodeBuild-Lambda-Deployment-Role-CMKPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "kms:RevokeGrant",
                          + "kms:RetireGrant",
                          + "kms:ReEncrypt*",
                          + "kms:ListGrants",
                          + "kms:GenerateDataKey*",
                          + "kms:Encrypt",
                          + "kms:DescribeKey",
                          + "kms:Decrypt",
                          + "kms:CreateGrant",
                        ]
                      + Effect   = "Allow"
                      + Resource = "arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
                      + Sid      = "LambdaPipelineCMKAccess"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.s3_policy[0] will be created
  + resource "aws_iam_role_policy" "s3_policy" {
      + id     = (known after apply)
      + name   = "CloudMage-CodeBuild-Lambda-Deployment-Role-S3Policy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "s3:PutObjectVersionTagging",
                          + "s3:PutObjectTagging",
                          + "s3:PutObject",
                          + "s3:ListBucket",
                          + "s3:GetObjectVersion",
                          + "s3:GetObject",
                          + "s3:GetBucketLocation",
                          + "s3:GetBucketAcl",
                          + "s3:DeleteObject",
                        ]
                      + Effect   = "Allow"
                      + Resource = [
                          + "arn:aws:s3:::kms-encrypted-demo-bucket/*",
                          + "arn:aws:s3:::kms-encrypted-demo-bucket",
                          + "arn:aws:s3:::demo-lambda-deploy-bucket/*",
                          + "arn:aws:s3:::demo-lambda-deploy-bucket",
                        ]
                      + Sid      = "LambdaPipelineS3Access"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

  # module.demo_codebuild_role.aws_iam_role_policy.sns_policy[0] will be created
  + resource "aws_iam_role_policy" "sns_policy" {
      + id     = (known after apply)
      + name   = "CloudMage-CodeBuild-Lambda-Deployment-Role-SNSPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = "sns:Publish"
                      + Effect   = "Allow"
                      + Resource = "arn:aws:sns:::CodeBuild-Notification-Topic"
                      + Sid      = "LambdaPipelineSNSAccess"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

Plan: 5 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

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
output "codebuild_role_id" {}
output "codebuild_role_arn" {}
```

<br><br>

# Module Output Usage

When using and calling the module within a root project, the output values of the module are available to the project root by simply referencing the module outputs from the root project `outputs.tf` file.

<br>

```terraform
######################
# S3 Bucket          #
######################
output "pipeline_role_id" {
  value = module.demo_codebuild_role.codebuild_role_id
}

output "pipeline_role_arn" {
  value = module.demo_codebuild_role.codebuild_role_arn
}
```

<br>

> __Note:__ When referencing the module outputs be sure that the output value contains the identifier given to the module call. As an example if the module was defined as `module "demo_codebuild_role" {}` then the output reference would be constructed as `module.demo_codebuild_role.pipeline_role_arn`.

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
