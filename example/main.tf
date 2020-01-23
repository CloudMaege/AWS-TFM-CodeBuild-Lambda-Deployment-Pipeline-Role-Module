# Terraform configuration 
terraform {
  required_version = ">= 0.12"
}

#Provider configuration. Typically there will only be one provider config, unless working with multi account and / or multi region resources
provider "aws" {
  region = var.provider_region
}

###################################
# CodeBuild Lambda Deployment Role
###################################

// Create the required CodeBuild Role
module "demo_codebuild_role" {
  source = "git@github.com:CloudMage-TF/AWS-CodeBuild-Lambda-Deployment-Pipeline-Role-Module.git?ref=v1.0.4"

  // Optional
  # codebuild_role_name               = var.role_name
  # codebuild_role_description        = var.role_description
  # codebuild_role_s3_resource_access = var.s3_resource_access
  # codebuild_sns_resource_access     = var.sns_resource_access
  # codebuild_cmk_resource_access     = var.cmk_resource_access
  # codebuild_role_tags               = var.role_tags
}
