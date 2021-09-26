
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc-${var.env}"
  cidr = var.vpc_cidr

  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = [var.elb_public_subnet]
  private_subnets = [var.private_subnet]

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_vpn_gateway   = false

  # Tags
  tags = var.tags
  
  //merge(var.tags , tomap(
    //{"Name" = "jenkins-vpc-${var.env}",  "Environment" = var.env}
    //{"a" = "foo", "b" = true}
  //)
}




module "jenkins_master_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-master-sg-${var.env}"
  description = "Security group that allows Jenkins master access only and all egress traffic"
  vpc_id      = module.vpc.vpc_id

   

  ingress_with_cidr_blocks = [

    {
      rule        = "http-80-tcp"
      description = "From the office only"
      cidr_blocks = var.elb_public_subnet
    },

    {
      rule        = "http-8080-tcp"
      description = "From the office only"
      cidr_blocks = var.elb_public_subnet
    },

    {
      rule        = "https-443-tcp"
      description = "From the office only"
      cidr_blocks = var.elb_public_subnet
    },
    {
      rule        = "ssh-tcp"
      description = "From the office only"
      cidr_blocks = var.elb_public_subnet
    },
      
      
    
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  # Tags
  tags = var.tags //merge(var.tags, tomap(
    //"Name", "jenkins-master-sg-${var.env}"
  //))
}




module "jenkins_slaves_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-slaves-sg-${var.env}"
  description = "Security group that allows Jenkins master subnet access (for monitoring later) and all egress traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [

    {
      rule        = "ssh-tcp"
      description = "From the office only"
      cidr_blocks = var.private_subnet
    },

    {
      //rule        = "http-49187-tcp"
      from_port   = var.jnlp_port
      to_port     = var.jnlp_port
      protocol    = "tcp"
      description = "JNLP from Jenkins master"
      cidr_blocks = var.private_subnet
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  # Tags
  tags = var.tags //merge(var.tags, tomap(
    //"Name", "jenkins-slaves-sg-${var.env}",
    //"Environment", var.env
  //))
}







































