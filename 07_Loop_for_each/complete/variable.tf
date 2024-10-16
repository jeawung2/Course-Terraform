variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {오후 7:40 2024-10-16
  description = "Public Subnets for VPC"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "private_subnets" {
  description = "Private Subnets for VPC"
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24"
  ]
}

variable "project" {
  type = map(any)

  default = {
    proj-alpha = {
      number_of_instances_per_subnet = 2,
      number_of_subnets              = 2,
      instance_type                  = "t3.micro",
      project_environment            = "dev"
    },
    proj-beta = {
      number_of_instances_per_subnet = 1,
      number_of_subnets              = 2,
      instance_type                  = "t3.nano",
      project_environment            = "test"
    }
  }
}
