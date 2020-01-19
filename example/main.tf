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
  source = "git@github.com:CloudMage-TF/TF-AWS-Lambda-Deploy-CodeBuild-Role-Module.git?ref=v1.0.1"

  // Optional
  // codebuild_role_name               = var.role_name
  // codebuild_role_description        = var.role_description
  // lambda_pipeline_s3_resource_list  = var.deployment_s3_resources
  // lambda_pipeline_sns_resource_list = var.deployment_sns_resources
  // lambda_pipeline_cmk_resource_list = var.deployment_cmk_resources
}
