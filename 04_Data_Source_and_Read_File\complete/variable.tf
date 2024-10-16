variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "myproject"
}

variable "project_environment" {
  description = "Name of the environment"
  type        = string
  default     = "development"
}

# variable "ami_image" {
#   description = "Ubuntu 20.04 LTS Image"
#   type        = map(string)
#   default = {
#     ap-northeast-1 = "ami-0ed99df77a82560e6" # Ubuntu 20.04 in Tokyo Region
#     ap-northeast-2 = "ami-04341a215040f91bb" # Ubuntu 20.04 in Seoul Region
#     us-east-2      = "ami-0d0c6a887ce442603" # Ubuntu 20.04 in Ohio Region
#     us-east-1      = "ami-0481e8ba7f486bd99" # Ubuntu 20.04 in N.Virginia Region
#   }
# }

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
