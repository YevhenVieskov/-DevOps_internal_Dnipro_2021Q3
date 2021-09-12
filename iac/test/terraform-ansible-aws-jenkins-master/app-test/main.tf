#provider "aws" {
  #version = "~> 1.16.0"
  #region = "${var.region}"
  #shared_credentials_file = "~/.aws/credentials"
 # profile                 = "${var.profile}"
#}

#terraform {
 # required_version = "~> 0.11.7"
  # backend "s3" {
  #   bucket = "ucd-gs-app-config"
  #   key    = "test/terraform/app-test.tfstate"
  #   region = "us-west-2"
  #   encrypt = true
  # }
#}

#provider "template" {
 # version = "~> 1.0.0"
#}

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
