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
