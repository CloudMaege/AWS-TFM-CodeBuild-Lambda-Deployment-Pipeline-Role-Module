######################
# Data Sources:      #
######################
data "aws_caller_identity" "current" {}

######################
# Local Variables:   #
######################
locals {
  bucket_wildcard_list = [for bucket in var.lambda_pipeline_s3_resource_list : format("%s/*", bucket) if length(var.lambda_pipeline_s3_resource_list) > 0]
}

##############################################
# Lambda Deployment CodeBuild Role Policies: #
##############################################
// CodeBuild Role Principal Assume Role Policy
data "aws_iam_policy_document" "principal_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com",
      ]
    }
  }
}

// CodeBuild Role Access Policies
data "aws_iam_policy_document" "access_policy" {

  // Logging
  statement {
    sid = "LambdaPipelineLogAccess"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:*"
    ]
  }

  // EC2 to allow CodeBuild to spin up its required resources
  statement {
    sid = "LambdaPipelineEC2Access"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = [
      "arn:aws:ec2::${data.aws_caller_identity.current.account_id}:network-interface/*",
      "arn:aws:ec2::${data.aws_caller_identity.current.account_id}:dhcp-options/*",
      "arn:aws:ec2::${data.aws_caller_identity.current.account_id}:subnet/*",
      "arn:aws:ec2::${data.aws_caller_identity.current.account_id}:security-group/*",
      "arn:aws:ec2::${data.aws_caller_identity.current.account_id}:vpc/*"
    ]
  }

  // Lambda
  statement {
    sid = "LambdaPipelineLambdaAccess"

    actions = [
      "lambda:*",
    ]

    resources = [
      "arn:aws:lambda::${data.aws_caller_identity.current.account_id}:event-source-mapping:*",
      "arn:aws:lambda::${data.aws_caller_identity.current.account_id}:function:*",
      "arn:aws:lambda::${data.aws_caller_identity.current.account_id}:layer:*",
      "arn:aws:lambda::${data.aws_caller_identity.current.account_id}:layer:*:*"
    ]
  }
  
  statement {
    sid = "LambdaPipelinePassRole"

    actions = [
      "iam:PassRole",
    ]

    resources = [
      "*"
    ]
  }
}

// Optional S3 Bucket Access
data "aws_iam_policy_document" "s3_policy" {
  count = "${length(var.lambda_pipeline_s3_resource_list)}" > 0 ? 1 : 0
  
  statement {
    sid = "LambdaPipelineS3Access"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion",
      "s3:ListBucket",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionTagging",
    ]
  
    resources = concat(var.lambda_pipeline_s3_resource_list, local.bucket_wildcard_list)
  }
}

// Optional SNS Topic Access
data "aws_iam_policy_document" "sns_policy" {
  count = "${length(var.lambda_pipeline_sns_resource_list)}" > 0 ? 1 : 0

  statement {
    sid = "LambdaPipelineSNSAccess"

    actions = [
      "sns:Publish",
    ]

    resources = var.lambda_pipeline_sns_resource_list
  }
}

// Optional KMS CMK Usage Access
data "aws_iam_policy_document" "cmk_policy" {
  count = "${length(var.lambda_pipeline_cmk_resource_list)}" > 0 ? 1 : 0

  statement {
    sid = "LambdaPipelineCMKAccess"

    actions = [
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt",
      "kms:ListGrants",
      "kms:CreateGrant",
      "kms:RevokeGrant",
    ]
  
    resources = var.lambda_pipeline_cmk_resource_list
  }
}

#####################################
# Lambda Deployment CodeBuild Role: #
#####################################
// Role
resource "aws_iam_role" "this" {
  name                 = "CodeBuild-Lambda-Pipeline-Service-Role"
  description          = "CodeBuild Role that allows CodeBuild to deploy Lambda Functions."
  max_session_duration = "14400"
  assume_role_policy   = data.aws_iam_policy_document.principal_policy.json
}

// Access Policy
resource "aws_iam_role_policy" "access_policy" {
  name   = "CodeBuild-Lambda-Pipeline-Service-Role-AccessPolicy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.access_policy.json
}

// Optional S3 Bucket Access
resource "aws_iam_role_policy" "s3_policy" {
  count  = "${length(var.lambda_pipeline_s3_resource_list)}" > 0 ? 1 : 0
  name   = "CodeBuild-Lambda-Pipeline-Service-Role-S3Policy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.s3_policy[count.index].json
}

// Optional SNS Topic Access
resource "aws_iam_role_policy" "sns_policy" {
  count  = "${length(var.lambda_pipeline_sns_resource_list)}" > 0 ? 1 : 0
  name   = "CodeBuild-Lambda-Pipeline-Service-Role-SNSPolicy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.sns_policy[count.index].json
}

// Optional KMS CMK Usage Policy
resource "aws_iam_role_policy" "cmk_policy" {
  count  = "${length(var.lambda_pipeline_cmk_resource_list)}" > 0 ? 1 : 0
  name   = "CodeBuild-Lambda-Pipeline-Service-Role-CMKPolicy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.cmk_policy[count.index].json
}