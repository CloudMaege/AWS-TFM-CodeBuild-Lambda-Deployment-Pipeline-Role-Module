# TF-AWS-Lambda-Deploy-CodeBuild-Role-Module CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<br>

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
