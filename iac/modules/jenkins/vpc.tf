
module "vpcjk" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr_jenkins

  azs             = ["${var.region}a", "${var.region}b"]  
  public_subnets  = [var.pub_a, var.pub_b]
  private_subnets = [var.pvt_a, var.pvt_b]

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

  name        = "jenkins-master-sg"
  description = "Security group that allows Jenkins master access only and all egress traffic"
  vpc_id      = module.vpcjk.vpc_id

   

  ingress_with_cidr_blocks = [

    {
      rule        = "http-80-tcp"
      description = "From internet"
      cidr_blocks = var.pub_b
    },

    {
      rule        = "http-8080-tcp"
      description = "From internet default jenkins port"
      cidr_blocks = var.pub_b
    },

    {
      rule        = "https-443-tcp"
      description = "From internet https"
      cidr_blocks = var.pub_b
    },
    {
      rule        = "ssh-tcp"
      description = "From internet ssh"
      cidr_blocks = var.pub_b
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

  name        = "jenkins-slaves-sg"
  description = "Security group that allows Jenkins master subnet access (for monitoring later) and all egress traffic"
  vpc_id      = module.vpcjk.vpc_id

  ingress_with_cidr_blocks = [

    {
      rule        = "ssh-tcp"
      description = "From the office only"
      cidr_blocks = var.pvt_b
    },

    {
      //rule        = "http-49187-tcp"
      from_port   = var.jnlp_port
      to_port     = var.jnlp_port
      protocol    = "tcp"
      description = "JNLP from Jenkins master"
      cidr_blocks = var.pvt_b
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









































