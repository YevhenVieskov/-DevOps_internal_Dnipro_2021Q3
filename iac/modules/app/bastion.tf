/*data "template_file" "bastion_init" {
  template = "${file("./bustion-setup.sh")}"
  vars = {    
  }
}*/

module "bastion" {
  source = "umotif-public/bastion/aws"
  #source = "./mbastion"

  name_prefix = "${var.env}"

  ami_id = data.aws_ami.ubuntu.id
  region = var.region
  availability_zones = ["${var.region}a", "${var.region}b"]
  


  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets                                #flatten([module.vpc.public_subnets])
  
  hosted_zone_id = var.hosted_zone_id
  ssh_key_name   = var.ssh_key_name

  enable_asg_scale_down = true
  enable_asg_scale_up   = true

  delete_on_termination = true
  volume_size           = var.bastion_volume_size
  encrypted             = true
  
  #user_data = filebase64("./ec2_setup.sh")
  #userdata_file_content = data.template_file.bastion_init
  userdata_file_content = templatefile("${path.module}/bastion_setup.sh", {}) # if you want to use default one, simply remove this line

  #depends_on = [aws_route53_zone.main]  ###

  tags = {
    Project = var.env
  }
}



























/*module "bastion" {
  source = "Guimove/bastion/aws"
  bucket_name = var.bastion_bucket_name
  region = var.region
  vpc_id = module.vpc.vpc_id
  is_lb_private = false     #"true|false"
  bastion_host_key_pair = var.ssh_key_name
  create_dns_record =  true                              #"true|false"
  hosted_zone_id = "dev.vieskov.com"
  bastion_record_name = "bastion.dev.vieskov.com"
  bastion_iam_policy_name = "myBastionHostPolicy"
  elb_subnets = module.vpc.public_subnets
  auto_scaling_group_subnets = module.vpc.public_subnets
  tags = {
    "name" = "vieskovtf_bastion",
    "description" = "vieskovtf_bastion_description"
  }
}*/










/*module "bastion" {
  source  = "infrablocks/bastion/aws"
  version = "0.1.2"

  region = "eu-west-2"
  vpc_id = "vpc-fb7dc365"
  subnet_ids = "subnet-ae4533c4,subnet-443e6b12"

  component = "important-component"
  deployment_identifier = "production"

  ami = "ami-bb373ddf"
  instance_type = "t2.micro"

  ssh_public_key_path = "~/.ssh/id_rsa.pub"

  allowed_cidrs = "100.10.10.0/24,200.20.0.0/16"
  egress_cidrs = "10.0.0.0/16"

  load_balancer_names = ["lb-12345678"]

  minimum_instances = 1
  maximum_instances = 3
  desired_instances = 2
}

provider "aws" {
  region = "eu-west-1"
}*/


/*
#####
# VPC and subnets
#####
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = "simple-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false

  tags = {
    Environment = "test"
  }
}



#####
# Bastion Host
#####
module "bastion" {
  source = "umotif-public/bastion/aws"

  name_prefix = "core-example"

  vpc_id         = module.vpc.vpc_id
  public_subnets = flatten([module.vpc.public_subnets])

  hosted_zone_id = "Z1IY32BQNIYX17"
  ssh_key_name   = "eks-test"

  enable_asg_scale_down = true
  enable_asg_scale_up   = true

  delete_on_termination = true
  volume_size           = 10
  encrypted             = true

  userdata_file_content = templatefile("./custom-userdata.sh", {}) # if you want to use default one, simply remove this line

  tags = {
    Project = "Test"
  }
}

output "sg_id" {
  value = module.bastion.security_group_id
}

module "bastion" {
  source = "umotif-public/bastion/aws"
  version = "~> 2.1.0"

  name_prefix = "core-example"

  vpc_id         = "vpc-abasdasd132"
  subnets        = ["subnet-abasdasd132123", "subnet-abasdasd132123132"]

  hosted_zone_id = "Z1IY32BQNIYX16"
  ssh_key_name   = "test"

  tags = {
    Project = "Test"
  }
}

*/




