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

  // Logging permissions to create and write to cloudwatch log groups
  statement {
    sid = "LambdaPipelineLogAccess"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
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

    resources = ["*"]
  }

  // Lambda access to create and maintain functions
  statement {
    sid = "LambdaPipelineLambdaAccess"

    actions = [
      "lambda:*",
    ]

    resources = ["*"]
  }
  
  // IAM Passrole so that codebuild can pass the lambda specific roles to the functions it creates
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
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt",
      "kms:ListGrants",
      "kms:CreateGrant",
      "kms:RetireGrant",
      "kms:RevokeGrant"
    ]
  
    resources = var.lambda_pipeline_cmk_resource_list
  }
}

#####################################
# Lambda Deployment CodeBuild Role: #
#####################################
// Role
resource "aws_iam_role" "this" {
  name                 = var.codebuild_role_name
  description          = var.codebuild_role_description
  max_session_duration = "14400"
  assume_role_policy   = data.aws_iam_policy_document.principal_policy.json
}

// Access Policy
resource "aws_iam_role_policy" "access_policy" {
  name   = "${var.codebuild_role_name}-AccessPolicy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.access_policy.json
}

// Optional S3 Bucket Access
resource "aws_iam_role_policy" "s3_policy" {
  count  = "${length(var.lambda_pipeline_s3_resource_list)}" > 0 ? 1 : 0
  name   = "${var.codebuild_role_name}-S3Policy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.s3_policy[count.index].json
}

// Optional SNS Topic Access
resource "aws_iam_role_policy" "sns_policy" {
  count  = "${length(var.lambda_pipeline_sns_resource_list)}" > 0 ? 1 : 0
  name   = "${var.codebuild_role_name}-SNSPolicy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.sns_policy[count.index].json
}

// Optional KMS CMK Usage Policy
resource "aws_iam_role_policy" "cmk_policy" {
  count  = "${length(var.lambda_pipeline_cmk_resource_list)}" > 0 ? 1 : 0
  name   = "${var.codebuild_role_name}-CMKPolicy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.cmk_policy[count.index].json
}