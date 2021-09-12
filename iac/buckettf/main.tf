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



# You cannot create a new backend by simply defining this and then
    # immediately proceeding to "terraform apply". The S3 backend must
    # be bootstrapped according to the simple yet essential procedure in
    # https://github.com/cloudposse/terraform-aws-tfstate-backend#usage
 /*   module "terraform_state_backend" {
      source = "cloudposse/tfstate-backend/aws"
      #source = https://github.com/cloudposse/terraform-aws-tfstate-backend.git
      # Cloud Posse recommends pinning every module to a specific version
      # version     = "x.x.x"
      namespace  = "eg"
      stage      = "dev"
      name       = "vieskovtfstate"
      attributes = ["state"]

      terraform_backend_config_file_path = "."
      terraform_backend_config_file_name = "backend.tf"
      force_destroy                      = false
    }*/

    # Your Terraform configuration
    #module "another_module" {
    #  source = "....."
    #}

/*    variable "bucket_name" {
    description = "the name to give the bucket"
}
variable "principals" {
    default     = ""
    description = "list of IAM user/role ARNs with access to the bucket"
}

provider "aws" { }

#terraform {
#  backend "s3" {
#    encrypt = "true"
#    bucket  = "fpco-tf-remote-state-test"
#    key     = "mod/remote-state-storage/terraform.tfstate"
#  }
#}

module "s3-remote-state-bucket" {
    source      = "fpco/foundation/aws//modules/s3-remote-state"
    bucket_name = "${var.bucket_name}"
}

output "bucket_name" {
    value = "${module.s3-remote-state-bucket.bucket_id}"
}

Create a terraform.tfvars, for example:

principals="<arn of principal>"
bucket_name="fpco-tf-remote-state-test"
region="us-east-1"

Now it's time to create the IAM policies and S3 bucket using Terraform.

    Initialize the project with terraform init.
    Review the changes Terraform will make with tf plan --out=tf.out, and
    Apply those changes with tf apply tf.out.

Initialize the Remote State S3 Backend

We want to use the newly created S3 bucket to store the Terraform state for this module. There are several steps that need to be taken. Make sure to backup your existing terraform.tfstate file before taking these steps:

    First we have to initialize the backend and copy over the current state of the backend bucket you just created. Uncomment the following, so that the code in the main.tf file looks similar to this:

terraform {
  backend "s3" {
    encrypt = "true"
    bucket  = "fpco-tf-remote-state-test"
    key     = "mod/remote-state-storage/terraform.tfstate"
  }
}*/


/*
notdownloaded from registry
module "backend" {
  #source    = "git::ssh://git@github.com/rhythmictech/terraform-aws-backend"
  #source    = "https://github.com/rhythmictech/terraform-aws-backend.git"
  source    = "rhythmictech/terraform-aws-backend/aws"
  bucket    = "project-tfstate"
  region    = "us-east-1"
  table     = "tf-locktable"
}*/

/*Example Config:

module "terraform_state_backend" {
  source  = "StratusGrid/terraform-state-s3-bucket-centralized-with-roles/aws"
  version = "2.0.0"
  # source  = "github.com/StratusGrid/terraform-aws-terraform-state-s3-bucket-centralized-with-roles"
  name_prefix = "mycompany"
  log_bucket_id = "${module.s3_bucket_logging.bucket_id}"
  account_arns = [
    "arn:aws:iam::123456789012:root",
    "arn:aws:iam::098765432109:root"
  ]
  global_account_arns = ["arn:aws:iam::123456789012:root"]
  input_tags = "${local.common_tags}"
}

output "terraform_state_kms_key_alias_arns" {
  value = "${module.terraform_state.kms_key_alias_arns}"
}

output "terraform_state_kms_key_arns" {
  value = "${module.terraform_state.kms_key_arns}"
}

output "terraform_state_iam_role_arns" {
  value = "${module.terraform_state.iam_role_arns}"
}

Example Backend Config:

terraform {
  backend "s3" {
    role_arn        = "arn:aws:iam::123456789012:role/123456789012-terraform-state"
    acl             = "bucket-owner-full-control"
    bucket          = "mycompany-remote-state-backend-anm1587s49"
    dynamodb_table  = "mycompany-remote-state-backend"
    encrypt         = true
    key             = "123456789012/mycompany-account-organization-master/terraform.tfstate"
    kms_key_id      = "arn:aws:kms:us-east-1:123456789012:key/4ryh7htp-FAKE-ARNS-DUDE-777d88512345"
    region          = "us-east-1"
  }
}

Example to Initialize the backend:

terraform init -backend-config="access_key=AKIAIOIEXAMPLEOXJA" -backend-config="secret_key=PiNMLcNOTAREALKEYGQGzz20v3"

NOTE: The access and secret keys used must have rights to assume the role created by the module

    This is usually automatically the case for any keys that have full admin rights in the account whose state is to be stored, or in one of the global accounts specified.
    Otherwise, this will need to be assigned manually. You can use this module to help with mapping those trusts: https://registry.terraform.io/modules/StratusGrid/iam-cross-account-trust-maps/aws
        Use trusting_arn to map a single trust (like for a standard account assumption policy)
        Use trusting_arns to map multiple trusts (like for a global account assumption policy)

Example Configuration on Global Users Account:

# This should have each terraform state role if you want a user to be able to apply terraform manually
locals {
  mycompany_organization_terraform_state_account_roles = [
    "arn:aws:iam::123456789012:role/210987654321-terraform-state",
    "arn:aws:iam::123456789012:role/123456789012-terraform-state"
  ]
}

# When require_mfa is set to true, terraform init and terraform apply would need to be run with your STS acquired temporary token
module "mycompany_organization_terraform_state_trust_maps" {
  source = "StratusGrid/iam-role-cross-account-trusting/aws"
  version = "1.1.0"
  trusting_role_arns = "${local.mycompany_organization_terraform_state_account_roles}"
  trusted_policy_name = "mycompany-organization-terraform-states"
  trusted_group_names = [
    "${aws_iam_group.mycompany_internal_admins.name}"
  ]
  trusted_role_names = []
  require_mfa = false
  input_tags = "${local.common_tags}"
}

Example config without trusting any other accounts

In this case, you just don't specific other accounts. Then, you use the default kms key along with the dynamodb table.

module "terraform_state" {
  source  = "StratusGrid/terraform-state-s3-bucket-centralized-with-roles/aws"
  version = "2.0.0"
  # source  = "github.com/StratusGrid/terraform-aws-terraform-state-s3-bucket-centralized-with-roles"
  
  name_prefix   = var.name_prefix
  name_suffix   = local.name_suffix
  log_bucket_id = module.s3_bucket_logging.bucket_id
  account_arns = [
  ]
  global_account_arns = []
  input_tags          = merge(local.common_tags, {})
}

output "terraform_state_kms_key_alias_arn" {
  value = "${module.terraform_state.kms_default_key_alias_arn}"
}

output "terraform_state_kms_key_arn" {
  value = "${module.terraform_state.kms_default_key_arn}"
}*/

Features

    Create a S3 bucket to store remote state files.
    Encrypt state files with KMS.
    Enable bucket replication and object versioning to prevent accidental data loss.
    Automatically transit non-current versions in S3 buckets to AWS S3 Glacier to optimize the storage cost.
    Optionally you can set to expire aged non-current versions(disabled by default).
    Create a DynamoDB table for state locking.
    Optionally create an IAM policy to allow permissions which Terraform needs.

Usage

The module outputs terraform_iam_policy which can be attached to IAM users, groups or roles running Terraform. This will allow the entity accessing remote state files and the locking table. This can optionally be disabled with terraform_iam_policy_create = false

/*provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "replica"
  region = "us-west-1"
}

module "remote_state" {
  source = "nozaq/remote-state-s3-backend/aws"

  providers = {
    aws         = aws
    aws.replica = aws.replica
  }
}

resource "aws_iam_user" "terraform" {
  name = "TerraformUser"
}

resource "aws_iam_user_policy_attachment" "remote_state_access" {
  user       = aws_iam_user.terraform.name
  policy_arn = module.remote_state.terraform_iam_policy.arn
}

Note that you need to provide two providers, one for the main state bucket and the other for the bucket to which the main state bucket is replicated to. Two providers must point to different AWS regions.

Once resources are created, you can configure your terraform files to use the S3 backend as follows.

terraform {
  backend "s3" {
    bucket         = "THE_NAME_OF_THE_STATE_BUCKET"
    key            = "some_environment/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "THE_ID_OF_THE_KMS_KEY"
    dynamodb_table = "THE_ID_OF_THE_DYNAMODB_TABLE"
  }
}

THE_NAME_OF_THE_STATE_BUCKET, THE_ID_OF_THE_DYNAMODB_TABLE and THE_ID_OF_THE_KMS_KEY can be replaced by state_bucket.bucket, dynamodb_table.id and kms_key.id in outputs from this module respectively.

See the official document for more detail.
*/

