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
