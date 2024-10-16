locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.project_environment
  }
}

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

resource "aws_instance" "instance_a" {
  ami                    = data.aws_ami.ubuntu_linux.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]

  # 1. Heredoc
  # user_data = <<-EOF
  #   #!/bin/bash
  #   apt update
  #   apt install -y apache2
  #   curl http://169.254.169.254/latest/meta-data/instance-id -o /var/www/html/index.html
  #   EOF
  # 2. File Function
  #user_data = file("${path.module}/script/userdata.sh")
  # 3. cloudinit_config Datasource
  user_data = data.cloudinit_config.init.rendered
  # 4. Templatefile Function
  #user_data = templatefile("${path.module}/template/userdata.tftpl", { message = "hello world" })

  tags = {
    Name = "instance-a-${local.suffix_name}"
  }
}

resource "aws_instance" "instance_b" {
  ami                    = data.aws_ami.ubuntu_linux.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = data.cloudinit_config.init.rendered

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

resource "aws_security_group" "web" {
  name = "allow-web"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sec-group-web-${local.suffix_name}"
  }
}
