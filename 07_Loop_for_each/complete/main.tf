data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  for_each = var.project

  name = "vpc-${each.key}-${each.value.project_environment}"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = slice(var.private_subnets, 0, each.value.number_of_subnets)
  public_subnets  = slice(var.public_subnets, 0, each.value.number_of_subnets)

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false
}

module "instance_security_group" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  for_each = var.project

  name        = "instance-sg-${each.key}-${each.value.project_environment}"
  description = "Security group for Instance with HTTP 80"
  vpc_id      = module.vpc[each.key].vpc_id

  ingress_cidr_blocks = module.vpc[each.key].public_subnets_cidr_blocks
}

module "lb_security_group" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  for_each = var.project

  name        = "lb-sg-${each.key}-${each.value.project_environment}"
  description = "Security group for LB with HTTP 80"
  vpc_id      = module.vpc[each.key].vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "elb" {
  source = "terraform-aws-modules/elb/aws"

  for_each = var.project

  name     = "elb-${each.key}-${each.value.project_environment}"
  internal = false

  security_groups = [module.lb_security_group[each.key].security_group_id]
  subnets         = module.vpc[each.key].public_subnets

  number_of_instances = each.value.number_of_instances_per_subnet * each.value.number_of_subnets
  instances           = module.ec2[each.key].instance_ids

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

module "ec2" {
  source = "./modules/instance"

  depends_on = [module.vpc]

  for_each = var.project

  project_name        = each.key
  project_environment = each.value.project_environment

  instance_type                  = each.value.instance_type
  number_of_instances_per_subnet = each.value.number_of_instances_per_subnet
  number_of_subnets              = each.value.number_of_subnets

  instance_subnet_ids = module.vpc[each.key].private_subnets
  instance_sg_ids     = [module.instance_security_group[each.key].security_group_id]
}
