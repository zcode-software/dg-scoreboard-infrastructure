variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-north-1"
}

variable "company_name" {
  description = "Name of the company"
  type        = string
  default     = "zcode"
}

variable "app_name" {
  description = "Name of the app"
  type        = string
  default     = "dg-scoreboard"
}

variable "github_cicd_issuer_url" {
  description = "The OIDC issuer URL for GitHub Actions"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "github_cicd_client_id" {
  description = "The expected audience claim in the OIDC token"
  type        = string
}

variable "github_cicd_repos_with_env" {
  description = "Whitelist of GitHub repositories and environments allowed to assume the role"
  type        = list(string)
}
