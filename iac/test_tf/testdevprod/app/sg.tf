module "db-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_for_database"
  description = "Security group for database"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules       = ["postgresql-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

module "web-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_for_apache"
  description = "Security group for web servers"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}

module "bastion-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_for_bastion"
  description = "Security group for bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]

}

module "alb-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_for_alb"
  description = "Security group for bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]

}