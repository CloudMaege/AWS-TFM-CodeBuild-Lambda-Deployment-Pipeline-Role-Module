variable "provider_region" {
  type        = string
  description = "AWS region to use when making calls to the AWS provider."
  default     = "us-east-1"
}

variable "role_name" {
  type        = string
  description = "Specify a name for the the Lambda Pipeline Service Role."
}

variable "role_description" {
  type        = string
  description = "Specify the description for the the Lambda Pipeline Service Role."
}

variable "deployment_s3_resources" {
  type        = list(string)
  description = "List of S3 Bucket ARNs that the CodeBuild Lambda Pipeline Service Role will be given access to."
  default     = []
}

variable "deployment_sns_resources" {
  type        = list(string)
  description = "List of SNS Topic ARNs that the CodeBuild Lambda Pipeline Service Role will be given access to."
  default     = []
}

variable "deployment_cmk_resources" {
  type        = list(string)
  description = "Optional - List of KMS CMK ARNs that the CodeBuild Lambda Pipeline Service Role will be given usage permissions to."
  default     = []
}

