resource "aws_instance" "instance_a" {
  ami           = "ami-04341a215040f91bb"
  instance_type = "t3.micro"

  tags = {
    Name = "instance-a"
  }
}

resource "aws_instance" "instance_b" {
  ami           = "ami-04341a215040f91bb"
  instance_type = "t3.micro"

  tags = {
    Name = "instance-b"
  }

  depends_on = [
    aws_s3_bucket.bucket
  ]
}

resource "aws_eip" "eip" {
  domain   = "vpc"
  instance = aws_instance.instance_a.id

  tags = {
    Name = "elastic-ip-instance-a"
  }
}

resource "random_string" "random" {
  length  = 10
  special = false
  lower   = true
  upper   = false
  numeric = true
}

resource "aws_s3_bucket" "bucket" {
  bucket = "mybucket-${random_string.random.result}"

  tags = {
    Name = "mybucket-${random_string.random.result}"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "index.html"
  source = "./index.html"
}
