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

resource "aws_s3_bucket" "terraform_state" {

  bucket = var.bucket_name

  // This is only here so we can destroy the bucket as part of automated tests. You should not copy this for production
  // usage
  force_destroy = true

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags ={
    Name = "StateLock"
  }
  
  depends_on = [aws_s3_bucket.terraform_state]

}



resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:sts::052776272001:federated-user/vieskovtf"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::vieskovtfstate"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:sts::052776272001:federated-user/vieskovtf"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::vieskovtfstate/terraform.tfstate"
        }
    ]
})

}

