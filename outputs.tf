###########################
# CodeBuild Service Role: #
###########################
output "codebuild_role_arn" {
  value = aws_iam_role.this.arn
}

output "codebuild_role_id" {
  value = aws_iam_role.this.id
}
