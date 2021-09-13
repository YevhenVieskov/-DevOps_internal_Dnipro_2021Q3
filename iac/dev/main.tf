terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"      
      version = "~> 3.57"
    }
  }

  
  required_version = ">= 1.0.4"
}


#servers

provider "aws" {
  profile = var.profile
  region  = var.region
}


module "app" {
  source  = "../app"
  #version = "~> 2.0"
  #[CONFIG ...]
}
