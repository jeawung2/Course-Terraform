variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "project_environment" {
  description = "Name of the environment"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "number_of_instances_per_subnet" {
  description = "Number of Instances per Subnet"
  type        = number
}

variable "number_of_subnets" {
  description = "Number of Subnets"
  type        = number
}

variable "instance_subnet_ids" {
  description = "Subnet ID of Instance"
  type = list(string)
}

variable "instance_sg_ids" {
  description = "Security Group IDs of Instance"
  type = list(string)
}
