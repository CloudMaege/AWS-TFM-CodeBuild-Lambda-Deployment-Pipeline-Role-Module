<!-- VSCode Markdown Exclusions-->
<!-- markdownlint-disable MD024 Multiple Headings with the Same Content-->
# CloudMage TF-AWS-CodeBuild-Lambda-Deployment-Pipeline-Role-Module CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<br>

## v1.0.4 - [2020-01-23]

### Added

- None

### Changed

- Provisoned_By tag spelling corrected to Provisioned_By
- Fixed all Documentation to address miss-spelled tag

### Removed

- None

<br><br>

## 1.0.3 - [2020-01-22]

### Added

- Added tagging logic to the codebuild role resources to give buckets any desired tags.
- Added merge to passed tags to also create Name, Created_By, Creator_ARN, Creation_Date and Updated_On auto tags.
- Lifecycle ignore_changes placed on Created_By, Creator_ARN, and Creation_Date auto tags.
- Updated_On tag unlike the others will automatically update on subsequent terraform apply executions.
- Added tags variable, and set value in example variables.tf and env.tfvars.

### Changed

- Put variables.tf example variables.tf and env.tfvars into consistant format.

### Removed

- None

<br><br>

## 1.0.2 - [2020-01-19]

### Added

- Added lambda_role_name variable to allow module consumer to give the role a custom name (variables.tf)
- Added lambda_role_description variable to allow module consumer to give the role a custom description (variables.tf)
- Added Test Example module example to repository

### Changed

- KMS policy alterered to give the policy the additional `GenerateDataKey*`, `RetireGrant` permissions (main.tf)
- Policy names altered to use the new lambda_role_name variable within each policy resource (main.tf)

### Removed

- None

<br><br>

## 1.0.1 - [2019-11-03]

### Added

- None

### Changed

- Permission restrictions on resources for 3 policies set to * as specifying individual resources was too restrictive.

### Removed

- None

<br><br>

## 1.0.0 - [2019-09-22]

### Added

- Functional module initial commit

### Changed

- None

### Removed

- None
