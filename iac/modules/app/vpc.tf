
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.env}-app-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = [var.pub_a, var.pub_b]
  private_subnets = [var.pvt_a, var.pvt_b]
  #database_subnets = [var.pvt_a, var.pvt_b]


  /*enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = false #true
  enable_vpn_gateway   = true
  one_nat_gateway_per_az = true*/

  #enable_nat_gateway   = false
  #enable_vpn_gateway   = false

  enable_nat_gateway   = true
  one_nat_gateway_per_az = true
  enable_vpn_gateway   = false
  create_igw           = true

  # Tags
  tags = var.tags
  

}


module "web" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "web-sg"
  description = "Security group that allows public inbound traffic"
  vpc_id      = module.vpc.vpc_id

   

  ingress_with_cidr_blocks = [

    {
      rule        = "http-80-tcp"
      description = "http "
      cidr_blocks = module.vpc.vpc_cidr_block
    },    

    {
      rule        = "https-443-tcp"
      description = "https"
      cidr_blocks = module.vpc.vpc_cidr_block
    },

    {
      rule        = "ssh-tcp"
      description = "ssh"
      cidr_blocks = module.vpc.vpc_cidr_block
    },

    {
      rule        = "all-icmp"
      description = "ssh"
      cidr_blocks = module.vpc.vpc_cidr_block
    },  
    
  ]

  egress_rules = ["all-all"]

  /*egress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = var.pvt_a
    },
  ]*/

  # Tags
  tags =  merge(var.tags, { Name = "Web Server" })
}


module "db" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db-sg"
  description = "Security group that allows public inbound traffic"
  vpc_id      = module.vpc.vpc_id   

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules       = ["mysql-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
 
  # Tags
  tags =  merge(var.tags, { Name = "Database Server" })
}


module "alb" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "alb-sg"
  description = "Security group that allows public inbound traffic"
  vpc_id      = module.vpc.vpc_id
   

  ingress_with_cidr_blocks = [

    {
      rule        = "http-80-tcp"
      description = "http "
      cidr_blocks = module.vpc.vpc_cidr_block
    },

    {
      rule        = "https-443-tcp"
      description = "https "
      cidr_blocks = module.vpc.vpc_cidr_block
    },    
  ]

  #egress_rules = ["all-all"]

  # Tags
  tags =  merge(var.tags, { Name = "ALB" })
}

















































