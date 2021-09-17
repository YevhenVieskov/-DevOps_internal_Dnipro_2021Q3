locals {
  subnet_ids = { for k, v in aws_subnet.this : v.tags.Name => v.id }

  common_tags = {
    Project   = "Vieskov AWS com Terraform"
    CreatedAt = "2021-09-16"
    ManagedBy = "Terraform"
    Owner     = "Yevhen Vieskov"
    Service   = "Auto Scaling App"
  }
}
