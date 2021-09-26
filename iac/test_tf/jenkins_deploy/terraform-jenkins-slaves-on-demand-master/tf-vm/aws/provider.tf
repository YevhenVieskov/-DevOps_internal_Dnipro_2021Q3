/*provider "aws" {
  region  = var.aws_region
  #version = "~> 2.7"
}

provider "template" {
  #version = "~> 2.1"
}

provider "null" {
  #version = "~> 2.1"
}*/


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"      
      version = "~> 3.57"
    }
  }
  
  required_version = ">= 1.0.4"
}


provider "aws" {
  profile = var.profile
  region  = var.region
}
