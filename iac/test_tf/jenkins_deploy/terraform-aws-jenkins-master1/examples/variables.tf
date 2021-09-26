#variables

variable "profile" {
  description = "AWS Profile"
  type        = string
  default     = "vieskovtf"
}

variable "principals" {    
    description = "list of IAM user/role ARNs with access to the bucket"
    type        =  string
    default     = "arn:aws:iam::052776272001:user/vieskovtf"
}

variable "region" {
  description = "Region for AWS resources"
  type        =  string
  default     =  "us-east-2"
}

variable "env" {
  description = "Environment"
  type        =  string
  default     =  "dev"
}

variable "tags" {
  description = "tag"  
  default     =   {
    key                 = "Name"
    value               = "jenkins"
    
    }
}


/*variable "storage_bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default     = "vieskovtf-tfstate-bucket"
}

variable "storage_table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        =   string
  default     = "vieskovtf-tfstate-lock-table" 
}*/