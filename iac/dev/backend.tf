terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "us-east-2"
    bucket         = "eg-dev-vieskovtfstate-state"
    key            = "terraform.tfstate"
    dynamodb_table = "eg-dev-vieskovtfstate-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
