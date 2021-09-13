#-------------------------------------------------
# Environment
#-------------------------------------------------

variable "env" {
  default = "test"
}

#variable "region" {
 # default = "us-west-2"
#}

variable "availability_zone" {
  default = "us-west-2a"
}
variable "target_region" {
  default = "us-east-1"
}

#variable "profile" {
 # default = "dinesh"
#}
variable "log_retention" {
  default = 365
}
variable "retentionDays" {
  default = "365"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}
variable "vm_user" {
  default = "ubuntu"
}

variable "key_name" {
  default = "terraform-ansible-key"
}
# variable "vpc_id" {
#   type = "string"
# }

variable "name" {
  default = "jenkins"
  description = "Security group name"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
