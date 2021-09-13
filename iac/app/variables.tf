
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

variable "storage_bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default ="vieskovtf-tfstate-bucket"
}

variable "storage_table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default ="vieskovtf-tfstate-lock-table" 
}

variable "vpc_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default ="vieskovtf-tfstate-lock-table" 
}




