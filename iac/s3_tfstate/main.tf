resource "aws_s3_bucket" "terraform_state_storage" {
  bucket = var.storage_bucket_name
  acl    = "private"

  tags = {
    name      = "Terraform Storage"
    dedicated = "Infrastructure"
  }

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

  lifecycle {
    prevent_destroy = true
  }
}

# create a dynamodb table for locking the state file.
# this is important when sharing the same state file across users
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = var.storage_table_name
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    name = "DynamoDB Terraform State Lock Table"
    dedicated = "Infrastructure"
  }

  lifecycle {
    prevent_destroy = true
  }
}

data "aws_iam_policy_document" "terraform_storage_state_access" {
  statement  {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads"      
    ]

    /*principals {
      type        = "AWS"
      identifiers = compact(["arn:aws:iam::052776272001:user/vieskovtf"])
    }*/

    resources = [
      aws_s3_bucket.terraform_state_storage.arn
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload"
    ]

    /*principals {
      type        = "AWS"
      identifiers = compact(["arn:aws:iam::052776272001:user/vieskovtf"])        #
    }*/

    resources = [
      "${aws_s3_bucket.terraform_state_storage.arn}/terraform.tfstate",      
    ]
  }
}

# Creates the IAM policy to allow access to the bucket
resource "aws_iam_policy" "terraform_storage_state_access" {
  name = "terraform_storage_state_access"
  policy = data.aws_iam_policy_document.terraform_storage_state_access.json
}

# Assigns the policy to the terraform user
resource "aws_iam_user_policy_attachment" "terraform_storage_state_attachment" {
  user       = var.profile
  policy_arn = aws_iam_policy.terraform_storage_state_access.arn
}


data "aws_iam_policy_document" "dynamodb_access" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]

    /*principals {
      type        = "AWS"
      identifiers =  compact(["arn:aws:iam::052776272001:user/vieskovtf"])         #compact(var.principals)
    }*/

    resources = [
      "arn:aws:dynamodb:*:*:table/terraform-state-lock"
    ]
  }
}

# Creates the IAM policy to allow access to the dynamoDB
resource "aws_iam_policy" "dynamodb_access" {
  name = "dynamodb_access"
  policy = data.aws_iam_policy_document.dynamodb_access.json
}

# Assigns the policy to the terraform user
resource "aws_iam_user_policy_attachment" "dynamodb_attachment" {
  user       = var.profile #local.terraform_user
  policy_arn = aws_iam_policy.dynamodb_access.arn
}



