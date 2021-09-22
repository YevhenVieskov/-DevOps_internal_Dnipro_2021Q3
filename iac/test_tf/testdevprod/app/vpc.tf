module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name_vpc
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = [var.pub_a, var.pub_b]
  private_subnets = [var.pvt_a, var.pvt_b]
  #database_subnets = [var.pvt_a, var.pvt_b]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  enable_dns_hostnames = true
  /*enable_nat_gateway   = true  
  single_nat_gateway   = false 
  enable_vpn_gateway   = true
  one_nat_gateway_per_az = true*/

}