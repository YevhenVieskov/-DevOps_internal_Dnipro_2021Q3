module "jmaster_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = var.jmname

  ami                    = data.aws_ami.ubuntu.id  
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  key_name               = var.ssh_key_name
  monitoring             = true
  vpc_security_group_ids = [module.jenkins_master_sg.security_group_id]       #module.vpc.public_subnets    
  subnet_id              = module.vpcjk.public_subnets[1] 

  user_data              = var.udata_jmaster != "" ? base64encode(var.udata_jmaster) : base64encode(file(var.udata_jmaster))
  #user_data = var.userdata_file_content != "" ? base64encode(var.userdata_file_content) : 
  #base64encode(templatefile("${path.module}/bastion-userdata.sh", { HOSTED_ZONE_ID = var.hosted_zone_id, NAME_PREFIX = var.name_prefix }))

  tags = {
    Terraform   = "true"
    Environment = var.jmname
  }
}


module "jslave_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = var.jsname

  ami                    = data.aws_ami.ubuntu.id  
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  key_name               = var.ssh_key_name
  monitoring             = true
  vpc_security_group_ids = [module.jenkins_master_sg.security_group_id]   
  subnet_id              = module.vpcjk.private_subnets[1] 

  user_data              = var.udata_jslave != "" ? base64encode(var.udata_jslave) : base64encode(file(var.udata_jslave)) 

  tags = {
    Terraform   = "true"
    Environment = var.jsname
  }
}




