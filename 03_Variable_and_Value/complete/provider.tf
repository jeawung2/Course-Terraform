terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}
