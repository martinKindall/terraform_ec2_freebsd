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

resource "aws_instance" "bsd_server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "frankfurt_key"
  vpc_security_group_ids  = [ "sg-098fa48f510116f9c" ]

  user_data = <<EOF
#!/bin/sh
pkg install vim
EOF

  tags = {
    Name = "bsd_server"
  }
}
