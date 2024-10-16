locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.project_environment
  }
}

locals {
  suffix_name = "${var.project_name}-${var.project_environment}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-${local.suffix_name}"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true 
  enable_vpn_gateway = false
}

module "instance_security_group" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "instance-sg-${local.suffix_name}"
  description = "Security group for Instance with HTTP 80"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks
}

module "lb_security_group" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "lb-sg-${local.suffix_name}"
  description = "Security group for LB with HTTP 80"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "elb" {
  source = "terraform-aws-modules/elb/aws"

  name     = "elb-${local.suffix_name}"
  internal = false

  security_groups = [module.lb_security_group.security_group_id]
  subnets         = module.vpc.public_subnets

  number_of_instances = 2
  instances           = [aws_instance.instance_a.id, aws_instance.instance_b.id]

  listener = [{
    instance_port     = "80"
    instance_protocol = "HTTP"
    lb_port           = "80"
    lb_protocol       = "HTTP"
  }]

  health_check = {
    target              = "HTTP:80/index.html"
    interval            = 10
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
  }
}

data "aws_ami" "ubuntu_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "cloudinit_config" "init" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "userdata.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/script/userdata.sh")
  }
}

resource "aws_instance" "instance_a" {
  depends_on = [module.vpc]

  ami           = data.aws_ami.ubuntu_linux.image_id
  instance_type = var.instance_type

  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.instance_security_group.security_group_id]

  user_data = data.cloudinit_config.init.rendered

  tags = {
    Name = "instance-a-${local.suffix_name}"
  }
}

resource "aws_instance" "instance_b" {
  depends_on = [module.vpc]

  ami           = data.aws_ami.ubuntu_linux.image_id
  instance_type = var.instance_type

  subnet_id              = module.vpc.private_subnets[1]
  vpc_security_group_ids = [module.instance_security_group.security_group_id]

  user_data = data.cloudinit_config.init.rendered

  tags = {
    Name = "instance-b-${local.suffix_name}"
  }
}
