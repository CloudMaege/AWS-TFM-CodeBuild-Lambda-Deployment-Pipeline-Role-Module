###########################################################################
# Optional CodeBuild IAM Lambda Deployment Role Module Vars:              #
#-------------------------------------------------------------------------#
# The following variables have default values already set by the module.  #
# They will not need to be included in a project root module variables.tf #
# file unless a non-default value needs be assigned to the variable.      #
###########################################################################
role_name           = "CloudMage-CodeBuild-Lambda-Deployment-Role"
role_description    = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
s3_resource_access  = ["arn:aws:s3:::kms-encrypted-demo-bucket", "arn:aws:s3:::demo-lambda-deploy-bucket"]
sns_resource_access = ["arn:aws:sns:::CodeBuild-Notification-Topic"]
cmk_resource_access = ["arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"]

role_tags           = {
    Provisoned_By   = "Terraform"
    GitHub_URL      = "https://github.com/CloudMage-TF/AWS-CodeBuild-Lambda-Deployment-Pipeline-Role-Module.git"
}
