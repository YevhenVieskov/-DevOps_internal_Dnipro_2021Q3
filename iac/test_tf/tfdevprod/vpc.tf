module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name_vpc
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false

}