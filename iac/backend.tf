/*terraform {
  required_version = ">= 0.13"
  backend "s3" {
    bucket         = "vieskovtf-tfstate-bucket"
    key            = "terraform.tfstate"                   // "app/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "vieskovtf-tfstate-lock-table"
  }
}*/

