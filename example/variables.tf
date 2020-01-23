###########################################################################
# Terraform Config Vars:                                                  #
###########################################################################
variable "provider_region" {
  type        = string
  description = "AWS region to use when making calls to the AWS provider."
  default     = "us-east-1"
}


###########################################################################
# Optional CodeBuild IAM Lambda Deployment Role Module Vars:              #
#-------------------------------------------------------------------------#
# The following variables have default values already set by the module.  #
# They will not need to be included in a project root module variables.tf #
# file unless a non-default value needs be assigned to the variable.      #
###########################################################################
variable "role_name" {
  type        = string
  description = "Specify a name for the the Lambda Pipeline Service Role."
}

variable "role_description" {
  type        = string
  description = "Specify the description for the the Lambda Pipeline Service Role."
}

variable "s3_resource_access" {
  type        = list(string)
  description = "List of S3 Bucket ARNs that the CodeBuild Lambda Pipeline Service Role will be given access to."
  default     = []
}

variable "sns_resource_access" {
  type        = list(string)
  description = "List of SNS Topic ARNs that the CodeBuild Lambda Pipeline Service Role will be given access to."
  default     = []
}

variable "cmk_resource_access" {
  type        = list(string)
  description = "Optional - List of KMS CMK ARNs that the CodeBuild Lambda Pipeline Service Role will be given usage permissions to."
  default     = []
}

variable "role_tags" {
  type        = map
  description = "Specify any tags that should be added to the CodeBuild IAM Role being provisioned."
  default     = {
    Provisoned_By     = "Terraform"
    Module_GitHub_URL = "https://github.com/CloudMage-TF/AWS-CodeBuild-Lambda-Deployment-Pipeline-Role-Module.git"
  }
}

