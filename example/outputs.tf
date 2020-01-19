###########################
# CodeBuild Service Role: #
###########################
output "role_id" {
  value = module.demo_codebuild_role.codebuild_role_id
}

output "role_arn" {
  value = module.demo_codebuild_role.codebuild_role_arn
}
