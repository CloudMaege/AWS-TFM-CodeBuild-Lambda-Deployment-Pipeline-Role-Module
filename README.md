# Terraform Lambda Deployment Pipeline CodeBuild Role Module

![Hero](images/tf_iam.png)

<br>

## Getting Started

This AWS IAM Role module is designed to produce a CodeBuild IAM role that will applied to the Lambda Deployment Pipeline CodeBuild Job. The Lambda Deployment Pipeline will have the ability to optionally pull and put Lambda packages on S3, Send SNS Topic notifications and build and deploy Lambda functions in a CI/CD pipeline, allowing code update on demand or via webhook triggers. This role will give the required permissions to necessary EC2 resources that CodeBuild needs to operate within a VPC, access to CloudWatch Logging, Lambda, and STS PassRole. It will also optionally assign permissions to S3 buckets, SNS Topics and KMS CMKs provided the cooresponding variables are supplied to the module.

<br>

## Module Pre-Requisites

No Pre-Requisites Defined.

<br>

## Module Usage

```terraform
module "lambda_pipeline_role" {
  source = "git@github.com:CloudMage-TF/TF-AWS-Lambda-Deploy-CodeBuild-Role-Module.git?ref=v1.0.0"

  // Optional
  lambda_pipeline_s3_resource_list  = []
  lambda_pipeline_sns_resource_list = []
  lambda_pipeline_cmk_resource_list = []
}
```

<br>

## Variables

The following variables are utilized by this module and cause the module to behave dynamically based upon the variables that are populated and passed into the module.

<br>

### ![Optional](images/optional.png) lambda_pipeline_s3_resource_list

-----

This variable can contain a list of AWS S3 Bucket ARNs that the CodeBuild Role will be given **CRUD** access to. For each bucket ARN provided, the module will create an IAM policy document that will automatically contain a wildcard entry along with the original bucket ARN.
`["arn:aws:s3:::bucket", "arn:aws:s3:::bucket/*"]`

<br>

```terraform
variable "lambda_pipeline_s3_resource_list" {
  type        = list(string)
  description = "List of S3 Bucket ARNs that the CodeBuild Lambda Pipeline Service Role will be given access to."
  default     = []
}
```

<br>

__EXAMPLE__: Include the following in your environments tfvars file

```terraform
lambda_pipeline_s3_resource_list = [
  "arn:aws:s3:::bucket"
]
```

<br><br>

### ![Optional](images/optional.png) lambda_pipeline_sns_resource_list

-----

This variable can contain a list of AWS SNS Topic ARNs that the CodeBuild Role will be given **Publish** access to in order to allow event notification alerting.

<br>

```terraform
variable "lambda_pipeline_sns_resource_list" {
  type        = list(string)
  description = "List of SNS Topic ARNs that the CodeBuild Lambda Pipeline Service Role will be given access to."
  default     = []
}
```

<br>

__EXAMPLE__: Include the following in your environments tfvars file

```terraform
lambda_pipeline_sns_resource_list = [
  "arn:aws:sns:::TopicName"
]
```

<br><br>

### ![Optional](images/optional.png) lambda_pipeline_cmk_resource_list

-----

This variable can contain a list of AWS KMS CMK ARNs that the CodeBuild Role will be given **Encrypt/Decrypt/ReEncrypt/CreateGrant/ListGrant/DeleteGrant** access to in order to allow access to optional objects stored in the optionally encrypted S3 bucket..

<br>

```terraform
variable "lambda_pipeline_cmk_resource_list" {
  type        = list(string)
  description = "Optional - List of KMS CMK ARNs that the CodeBuild Lambda Pipeline Service Role will be given usage permissions to."
  default     = []
}
```

<br>

__EXAMPLE__: Include the following in your environments tfvars file

```terraform
lambda_pipeline_cmk_resource_list = [
  "arn:aws:kms:us-west-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
]
```

<br><br>

## Example

Using the module, and passing in S3, SNS, and KMS values would result in a role being produced with the following permission set:

<br>

```terraform
terraform apply

Configuring the terraform backend
Upgrading modules...
Downloading git@github.com:modules/TF-AWS-KMS-Module.git?ref=v1.0.1 for kms...
- kms in .terraform/modules/kms
Downloading git@github.com:modules/TF-AWS-Lambda-Deploy-CodeBuild-Role-Module.git?ref=v1.0.0 for role...
- role in .terraform/modules/role
Downloading git@github.com:modules/TF-AWS-S3Bucket-OptionalEncryption-Module.git?ref=v1.0.2 for s3...
- s3 in .terraform/modules/s3

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "aws" (hashicorp/aws) 2.33.0...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.aws: version = "~> 2.33"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Switching to workspace dev
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.terraform_remote_state.vpc: Refreshing state...
module.role.data.aws_iam_policy_document.principal_policy: Refreshing state...
module.kms.data.aws_caller_identity.current: Refreshing state...
module.s3.data.aws_region.current: Refreshing state...
module.role.data.aws_caller_identity.current: Refreshing state...
module.s3.data.aws_caller_identity.current: Refreshing state...
data.aws_caller_identity.current: Refreshing state...
module.s3.data.aws_iam_policy_document.this: Refreshing state...
module.kms.data.aws_iam_policy_document.kms_owner_policy: Refreshing state...
module.kms.data.aws_iam_policy_document.kms_resource_policy: Refreshing state...
module.kms.data.aws_iam_policy_document.kms_admin_policy: Refreshing state...
module.role.data.aws_iam_policy_document.access_policy: Refreshing state...
module.kms.data.aws_iam_policy_document.kms_user_policy: Refreshing state...
module.kms.data.aws_iam_policy_document.temp_kms_owner_kms_admin_merge_policy: Refreshing state...
module.kms.data.aws_iam_policy_document.temp_kms_admin_kms_user_merge_policy: Refreshing state...
module.kms.data.aws_iam_policy_document.this: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # aws_sns_topic.events will be created
  + resource "aws_sns_topic" "events" {
      + arn               = (known after apply)
      + display_name      = "Lambda-Deployment-Pipeline-Event-Notifications"
      + id                = (known after apply)
      + kms_master_key_id = (known after apply)
      + name              = "lambda_deployment_pipeline"
      + policy            = (known after apply)
    }

  # module.kms.aws_kms_alias.this will be created
  + resource "aws_kms_alias" "this" {
      + arn            = (known after apply)
      + id             = (known after apply)
      + name           = "alias/lambda/pipeline"
      + target_key_arn = (known after apply)
      + target_key_id  = (known after apply)
    }

  # module.kms.aws_kms_key.this will be created
  + resource "aws_kms_key" "this" {
      + arn                     = (known after apply)
      + deletion_window_in_days = 30
      + description             = "KMS CMK that will be used to encrypt objects and resources used in the lambda deployment pipeline."
      + enable_key_rotation     = true
      + id                      = (known after apply)
      + is_enabled              = true
      + key_id                  = (known after apply)
      + key_usage               = (known after apply)

  # module.role.data.aws_iam_policy_document.cmk_policy[0] will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "cmk_policy"  {
      + id   = (known after apply)
      + json = (known after apply)

      + statement {
          + actions   = [
              + "kms:CreateGrant",
              + "kms:Decrypt",
              + "kms:DescribeKey",
              + "kms:Encrypt",
              + "kms:ListGrants",
              + "kms:ReEncrypt*",
              + "kms:RevokeGrant",
            ]
          + resources = [
              + (known after apply),
            ]
          + sid       = "LambdaPipelineCMKAccess"
        }
    }

  # module.role.data.aws_iam_policy_document.s3_policy[0] will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "s3_policy"  {
      + id   = (known after apply)
      + json = (known after apply)

      + statement {
          + actions   = [
              + "s3:DeleteObject",
              + "s3:GetBucketAcl",
              + "s3:GetBucketLocation",
              + "s3:GetObject",
              + "s3:GetObjectVersion",
              + "s3:ListBucket",
              + "s3:PutObject",
              + "s3:PutObjectTagging",
              + "s3:PutObjectVersionTagging",
            ]
          + resources = [
              + (known after apply),
              + (known after apply),
            ]
          + sid       = "LambdaPipelineS3Access"
        }
    }

  # module.role.data.aws_iam_policy_document.sns_policy[0] will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "sns_policy"  {
      + id   = (known after apply)
      + json = (known after apply)

      + statement {
          + actions   = [
              + "sns:Publish",
            ]
          + resources = [
              + (known after apply),
            ]
          + sid       = "LambdaPipelineSNSAccess"
        }
    }

  # module.role.aws_iam_role.this will be created
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

  # module.role.aws_iam_role_policy.access_policy will be created
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
                      + Resource = "arn:aws:logs:*:123456789101:*"
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
                      + Resource = [
                          + "arn:aws:ec2::123456789101:vpc/*",
                          + "arn:aws:ec2::123456789101:subnet/*",
                          + "arn:aws:ec2::123456789101:security-group/*",
                          + "arn:aws:ec2::123456789101:network-interface/*",
                          + "arn:aws:ec2::123456789101:dhcp-options/*",
                        ]
                      + Sid      = "LambdaPipelineEC2Access"
                    },
                  + {
                      + Action   = "lambda:*"
                      + Effect   = "Allow"
                      + Resource = [
                          + "arn:aws:lambda::123456789101:layer:*:*",
                          + "arn:aws:lambda::123456789101:layer:*",
                          + "arn:aws:lambda::123456789101:function:*",
                          + "arn:aws:lambda::123456789101:event-source-mapping:*",
                        ]
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

  # module.role.aws_iam_role_policy.cmk_policy[0] will be created
  + resource "aws_iam_role_policy" "cmk_policy" {
      + id     = (known after apply)
      + name   = "CodeBuild-Lambda-Pipeline-Service-Role-CMKPolicy"
      + policy = (known after apply)
      + role   = (known after apply)
    }

  # module.role.aws_iam_role_policy.s3_policy[0] will be created
  + resource "aws_iam_role_policy" "s3_policy" {
      + id     = (known after apply)
      + name   = "CodeBuild-Lambda-Pipeline-Service-Role-S3Policy"
      + policy = (known after apply)
      + role   = (known after apply)
    }

  # module.role.aws_iam_role_policy.sns_policy[0] will be created
  + resource "aws_iam_role_policy" "sns_policy" {
      + id     = (known after apply)
      + name   = "CodeBuild-Lambda-Pipeline-Service-Role-SNSPolicy"
      + policy = (known after apply)
      + role   = (known after apply)
    }

  # module.s3.aws_s3_bucket.encrypted_bucket[0] will be created
  + resource "aws_s3_bucket" "encrypted_bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "123456789101-lambda-artifact-bucket-us-east-1"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + policy                      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "s3:*"
                      + Condition = {
                          + Bool = {
                              + aws:SecureTransport = "false"
                            }
                        }
                      + Effect    = "Deny"
                      + Principal = {
                          + AWS = "*"
                        }
                      + Resource  = [
                          + "arn:aws:s3:::123456789101-lambda-artifact-bucket-us-east-1/*",
                          + "arn:aws:s3:::123456789101-lambda-artifact-bucket-us-east-1",
                        ]
                      + Sid       = "DenyNonSecureTransport"
                    },
                  + {
                      + Action    = "s3:PutObject"
                      + Condition = {
                          + StringNotEquals = {
                              + s3:x-amz-server-side-encryption = [
                                  + "aws:kms",
                                  + "AES256",
                                ]
                            }
                        }
                      + Effect    = "Deny"
                      + Principal = {
                          + AWS = "*"
                        }
                      + Resource  = [
                          + "arn:aws:s3:::123456789101-lambda-artifact-bucket-us-east-1/*",
                          + "arn:aws:s3:::123456789101-lambda-artifact-bucket-us-east-1",
                        ]
                      + Sid       = "DenyIncorrectEncryptionHeader"
                    },
                  + {
                      + Action    = "s3:PutObject"
                      + Condition = {
                          + Null = {
                              + s3:x-amz-server-side-encryption = "true"
                            }
                        }
                      + Effect    = "Deny"
                      + Principal = {
                          + AWS = "*"
                        }
                      + Resource  = [
                          + "arn:aws:s3:::123456789101-lambda-artifact-bucket-us-east-1/*",
                          + "arn:aws:s3:::123456789101-lambda-artifact-bucket-us-east-1",
                        ]
                      + Sid       = "DenyUnEncryptedObjectUploads"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + region                      = "us-east-1"
      + request_payer               = (known after apply)
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + server_side_encryption_configuration {
          + rule {
              + apply_server_side_encryption_by_default {
                  + kms_master_key_id = (known after apply)
                  + sse_algorithm     = (known after apply)
                }
            }
        }

      + versioning {
          + enabled    = true
          + mfa_delete = false
        }
    }

Plan: 10 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.

Releasing state lock. This may take a few moments...


Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:

codebuild_role_arn = arn:aws:iam::123456789101:role/CodeBuild-Lambda-Pipeline-Service-Role
codebuild_role_id = CodeBuild-Lambda-Pipeline-Service-Role
kms_key_alias = arn:aws:kms:us-east-1:123456789101:alias/lambda/pipeline
kms_key_arn = arn:aws:kms:us-east-1:123456789101:key/a1bc2d34-5678-9109-e87f-65e432d12cba
kms_key_id = a1bc2d34-5678-9109-e87f-65e432d12cba
s3_bucket_arn = [
  "arn:aws:s3:::123456789101-lambda-artifact-bucket-us-east-1",
]
s3_bucket_domain_name = [
  "123456789101-lambda-artifact-bucket-us-east-1.s3.amazonaws.com",
]
s3_bucket_id = [
  "123456789101-lambda-artifact-bucket-us-east-1",
]
s3_bucket_region = [
  "us-east-1",
]
security_group_arn = arn:aws:ec2:us-east-1:123456789101:security-group/sg-001230ab123c54321
security_group_id = sg-001230ab123c54321
security_group_name = Lambda-Pipeline-SG
security_group_vpc_id = vpc-01ab23456789c8765
sns_topic_arn = arn:aws:sns:us-east-1:123456789101:lambda_deployment_pipeline
sns_topic_id = arn:aws:sns:us-east-1:123456789101:lambda_deployment_pipeline
```

![Lambda-Pipeline-CodeBuild-Role.png](images/Lambda-Pipeline-CodeBuild-Role.png)

<br>

__CodeBuild-Lambda-Pipeline-Service-Role-AccessPolicy__

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LambdaPipelineLogAccess",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": "arn:aws:logs:*:123456789101:*"
        },
        {
            "Sid": "LambdaPipelineEC2Access",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeDhcpOptions",
                "ec2:DeleteNetworkInterface",
                "ec2:CreateNetworkInterfacePermission",
                "ec2:CreateNetworkInterface"
            ],
            "Resource": [
                "arn:aws:ec2::123456789101:vpc/*",
                "arn:aws:ec2::123456789101:subnet/*",
                "arn:aws:ec2::123456789101:security-group/*",
                "arn:aws:ec2::123456789101:network-interface/*",
                "arn:aws:ec2::123456789101:dhcp-options/*"
            ]
        },
        {
            "Sid": "LambdaPipelineLambdaAccess",
            "Effect": "Allow",
            "Action": "lambda:*",
            "Resource": [
                "arn:aws:lambda::123456789101:layer:*:*",
                "arn:aws:lambda::123456789101:layer:*",
                "arn:aws:lambda::123456789101:function:*",
                "arn:aws:lambda::123456789101:event-source-mapping:*"
            ]
        },
        {
            "Sid": "LambdaPipelinePassRole",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*"
        }
    ]
}
```

<br>

__CodeBuild-Lambda-Pipeline-Service-Role-CMKPolicy__

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LambdaPipelineCMKAccess",
            "Effect": "Allow",
            "Action": [
                "kms:RevokeGrant",
                "kms:ReEncrypt*",
                "kms:ListGrants",
                "kms:Encrypt",
                "kms:DescribeKey",
                "kms:Decrypt",
                "kms:CreateGrant"
            ],
            "Resource": "arn:aws:kms:us-east-1:123456789101:key/a1bc2d34-5678-9109-e87f-65e432d12cba"
        }
    ]
}
```

<br>

__CodeBuild-Lambda-Pipeline-Service-Role-S3Policy__

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LambdaPipelineS3Access",
            "Effect": "Allow",
            "Action": [
                "s3:PutObjectVersionTagging",
                "s3:PutObjectTagging",
                "s3:PutObject",
                "s3:ListBucket",
                "s3:GetObjectVersion",
                "s3:GetObject",
                "s3:GetBucketLocation",
                "s3:GetBucketAcl",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::123456789101-lambda-artifact-bucket-us-east-1/*",
                "arn:aws:s3:::123456789101-lambda-artifact-bucket-us-east-1"
            ]
        }
    ]
}
```

<br>

__CodeBuild-Lambda-Pipeline-Service-Role-SNSPolicy__

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LambdaPipelineSNSAccess",
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": "arn:aws:sns:us-east-1:123456789101:lambda_deployment_pipeline"
        }
    ]
}
```

<br><br>

## Outputs

The template will finally create the following outputs that can be pulled and used in subsequent terraform runs via data sources. The outputs will be written to the terraform state file.

<br>

```terraform
######################
# S3 Bucket:         #
######################
output "codebuild_role_arn" {}
output "codebuild_role_id" {}
```

<br>

## Dependencies

### Required

* [Terraform](https://www.terraform.io/)
* [GIT](https://git-scm.com/download/win)
* [AWS-Account](https://https://aws.amazon.com/)

### Recommended

* [Terraform for VSCode](https://github.com/mauve/vscode-terraform)
* [Terraform Config Inspect](https://github.com/hashicorp/terraform-config-inspect)

<br>

## Contributions and Contacts

This project is owned by [CloudMage](rnason@cloudmage.io).

To contribute, please:

* Fork the project
* Create a local branch
* Submit Changes
* Create A Pull Request
