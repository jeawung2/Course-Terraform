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
  region  = "ap-northeast-2"
}

resource "aws_instance" "instance" {
  ami           = "ami-09a7535106fbd42d5"
  instance_type = "t3.micro"

  tags = {
    Name = "instance"
  }
}
