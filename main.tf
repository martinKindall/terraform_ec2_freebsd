terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "bsd_server_sg" {
  name        = "bsd_server_sg"
  description = "Allow HTTP and SSH to web server from anywhere"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.bsd_server_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.bsd_server_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "http" {
  security_group_id = aws_security_group.bsd_server_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_instance" "bsd_server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "frankfurt_key"
  vpc_security_group_ids  = [ aws_security_group.bsd_server_sg.id ]

  user_data = <<EOF
#!/bin/sh
pkg install -y vim git apache24
sysrc apache24_enable=yes

echo "<h1>Hello world from FreeBSD running on EC2!</h1>" > /usr/local/www/apache24/data/index.html

service apache24 start

EOF

  tags = {
    Name = "bsd_server"
  }
}
