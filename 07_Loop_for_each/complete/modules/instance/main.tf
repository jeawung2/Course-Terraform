locals {
  suffix_name = "${var.project_name}-${var.project_environment}"
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

resource "aws_instance" "instance" {
  count = var.number_of_subnets * var.number_of_instances_per_subnet

  ami           = data.aws_ami.ubuntu_linux.image_id
  instance_type = var.instance_type

  subnet_id              = var.instance_subnet_ids[count.index % var.number_of_subnets]
  vpc_security_group_ids = var.instance_sg_ids

  user_data = data.cloudinit_config.init.rendered

  tags = {
    Name = "instance-${count.index}-${local.suffix_name}"
  }
}
