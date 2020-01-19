# CodeBuild Lambda Pipeline Role Module Variables #
###################################################
role_name                = "CloudMage-CodeBuild-Lambda-Deployment-Role"
role_description         = "This role is used by codebuild to deploy lambdas for applications app_a, app_b, and app_c."
deployment_s3_resources  = ["arn:aws:s3:::kms-encrypted-demo-bucket", "arn:aws:s3:::demo-lambda-deploy-bucket"]
deployment_sns_resources = ["arn:aws:sns:::CodeBuild-Notification-Topic"]
deployment_cmk_resources = ["arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"]

