terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "= 3.27"
      version = "~> 3.57"
    }
  }

  #required_version = "= 0.12.25"
  #required_version = "= 0.14"
  required_version = ">= 1.0.4"
}

#variables

variable "profile" {
  description = "AWS Profile"
  type        = string
  default     = "vieskovtf"
}

variable "region" {
  description = "Region for AWS resources"
  type        = string
  default     = "us-east-2"
}

#servers

provider "aws" {
  profile = var.profile
  region  = var.region
}



resource "aws_instance" "web" {
  ami           = "ami-0d563aeddd4be7fff"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
  
  key_name = "vieskovtf"
}

