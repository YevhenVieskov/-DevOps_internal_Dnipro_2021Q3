
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.env}-app-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = [var.pub_a, var.pub_b]
  private_subnets = [var.pvt_a, var.pvt_b]
  #database_subnets = [var.pvt_a, var.pvt_b]


  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = false #true
  enable_vpn_gateway   = true
  one_nat_gateway_per_az = true

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
      cidr_blocks = var.allowed_inbound_cidr_blocks
    },

    

    {
      rule        = "https-443-tcp"
      description = "https"
      cidr_blocks = var.allowed_inbound_cidr_blocks
    },
    {
      rule        = "ssh-tcp"
      description = "ssh"
      cidr_blocks = var.allowed_inbound_cidr_blocks
    },
      
      
    
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = var.pvt_a
    },
  ]

  # Tags
  tags =  merge(var.tags, { Name = "Web Server" })
}


module "db" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db-sg"
  description = "Security group that allows public inbound traffic"
  vpc_id      = module.vpc.vpc_id   

  ingress_with_cidr_blocks = [
    
    
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      description = "DB Connection"
      cidr_blocks = var.pvt_a
      
    },
    
    {
      rule        = "ssh-tcp"
      description = "ssh"
      cidr_blocks = var.vpc_cidr
    }, 
    
  ]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.web.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_with_cidr_blocks = [

    {
      rule        = "http-80-tcp"
      description = "http "
      cidr_blocks = var.allowed_inbound_cidr_blocks
    },    

    {
      rule        = "https-443-tcp"
      description = "https"
      cidr_blocks = var.allowed_inbound_cidr_blocks
    },
    
  ]
  # Tags
  tags =  merge(var.tags, { Name = "Web Server" })
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
      cidr_blocks = var.allowed_inbound_cidr_blocks
    },     
    
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "lb outbound"
      cidr_blocks = var.allowed_inbound_cidr_blocks #egress traffic to private netwok
      
    },
  ]

  # Tags
  tags =  merge(var.tags, { Name = "Web Server" })
}


module "autoscaling" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "autoscaling-sg"
  description = "Security group that allows public inbound traffic"
  vpc_id      = module.vpc.vpc_id

   

  ingress_with_cidr_blocks = [

    {
      rule        = "ssh-tcp"
      description = "ssh"
      cidr_blocks = var.allowed_inbound_cidr_blocks
    },
    
    {
      rule        = "http-80-tcp"
      description = "http "
      cidr_blocks = var.allowed_inbound_cidr_blocks
    },     
    
  ]


  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "autoscaling outbound"
      cidr_blocks = var.allowed_inbound_cidr_blocks
      
    },
  ]

  # Tags
  tags =  merge(var.tags, { Name = "Auto Scaling" })
}
















































