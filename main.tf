provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "dg_scoreboard_frontend_bucket" {
  bucket = "${var.company_name}-${var.app_name}-${var.environment}-frontend"
}