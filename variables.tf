variable "codebuild_role_name" {
  type        = string
  description = "Specify a name for the the Lambda Pipeline Service Role."
  default     = "CodeBuild-Lambda-Pipeline-Service-Role"
}

variable "codebuild_role_description" {
  type        = string
  description = "Specify the description for the the Lambda Pipeline Service Role."
  default     = "CodeBuild Role that allows CodeBuild to deploy Lambda Functions."
}

variable "lambda_pipeline_s3_resource_list" {
  type        = list(string)
  description = "List of S3 Bucket ARNs that the CodeBuild Lambda Pipeline Service Role will be given access to."
  default     = []
}

variable "lambda_pipeline_sns_resource_list" {
  type        = list(string)
  description = "List of SNS Topic ARNs that the CodeBuild Lambda Pipeline Service Role will be given access to."
  default     = []
}

variable "lambda_pipeline_cmk_resource_list" {
  type        = list(string)
  description = "Optional - List of KMS CMK ARNs that the CodeBuild Lambda Pipeline Service Role will be given usage permissions to."
  default     = []
}
