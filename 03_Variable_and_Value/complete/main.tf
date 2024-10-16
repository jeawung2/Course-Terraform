locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.project_environment
  }
}

locals {
  suffix_name 오후 7:16 2024-10-16= "${var.project_name}-${var.project_environment}"
}

resource "aws_instance" "instance_a" {
  ami           = var.ami_image[var.aws_region]
  instance_type = var.instance_type

  tags = {
    Name = "instance-a-${local.suffix_name}"
  }
}

resource "aws_instance" "instance_b" {
  ami           = var.ami_image[var.aws_region]
  instance_type = var.instance_type

  tags = {
    Name = "instance-b-${local.suffix_name}"
  }
}

resource "aws_eip" "eip_a" {
  domain   = "vpc"
  instance = aws_instance.instance_a.id

  tags = {
    Name = "elastic-ip-instance-a-${local.suffix_name}"
  }
}

resource "aws_eip" "eip_b" {
  domain   = "vpc"
  instance = aws_instance.instance_b.id

  tags = {
    Name = "elastic-ip-instance-b-${local.suffix_name}"
  }
}
