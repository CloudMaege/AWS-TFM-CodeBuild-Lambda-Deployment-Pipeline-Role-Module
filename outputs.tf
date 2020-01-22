###################################
# CodeBuild Service Role Outputs: #
###################################
output "codebuild_role_id" {
  value = aws_iam_role.this.id
}

output "codebuild_role_arn" {
  value = aws_iam_role.this.arn
}
