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

variable "environment" {}
