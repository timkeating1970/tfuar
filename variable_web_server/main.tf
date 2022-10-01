terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.32.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "web-server" {
  ami                    = "ami-097a2df4ac947655f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.ingress_ports} &
              EOF

  tags = {
    Name     = "Variable Web Server"
    Function = "Marketing"
    Owner    = "Tim Keating"
  }
}

resource "aws_security_group" "instance" {

    name = var.security_group_name

  ingress {
    from_port   = var.ingress_ports
    to_port     = var.ingress_ports
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "security_group_name" {
  description = "The name of your security group"
  type = string
  default = "terraform-example-instance-2"
}

variable "ingress_ports" {
  description = "ingress ports for variable_web_server"
  type = number
  default = 8080
}

output "public_ip" {
  value = aws_instance.web-server.public_ip
  description = "This is the public IP address"
}