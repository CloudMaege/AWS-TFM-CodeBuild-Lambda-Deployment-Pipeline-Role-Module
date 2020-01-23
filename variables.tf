###########################################################################
# Optional CodeBuild IAM Lambda Deployment Role Module Vars:              #
#-------------------------------------------------------------------------#
# The following variables have default values already set by the module.  #
# They will not need to be included in a project root module variables.tf #
# file unless a non-default value needs be assigned to the variable.      #
###########################################################################
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

variable "codebuild_role_s3_resource_access" {
  type        = list(string)
  description = "List of S3 Bucket ARNs that the CodeBuild Lambda Pipeline Service Role will be given access to."
  default     = []
}

variable "codebuild_sns_resource_access" {
  type        = list(string)
  description = "List of SNS Topic ARNs that the CodeBuild Lambda Pipeline Service Role will be given access to."
  default     = []
}

variable "codebuild_cmk_resource_access" {
  type        = list(string)
  description = "Optional - List of KMS CMK ARNs that the CodeBuild Lambda Pipeline Service Role will be given usage permissions to."
  default     = []
}

variable "codebuild_role_tags" {
  type        = map
  description = "Specify any tags that should be added to the IAM CodeBuild Service Role being provisioned."
  default     = {
    Provisoned_By     = "Terraform"
    Module_GitHub_URL = "https://github.com/CloudMage-TF/AWS-CodeBuild-Lambda-Deployment-Pipeline-Role-Module.git"
  }
}
