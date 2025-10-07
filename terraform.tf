terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.15"
    }
  }

  backend "s3" {
    bucket = ""
    key    = "dg-scoreboard-infrastructure/state.tfstate"
    region = "eu-north-1"
  }

  required_version = ">= 1.13"
}
