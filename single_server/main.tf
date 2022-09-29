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

resource "aws_instance" "example" {
  ami           = "ami-097a2df4ac947655f"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform Example"
  }
}