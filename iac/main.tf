#################
# Jenkins
#################

module "jenkins" {
  source  = "./modules/jenkins"
  
  region            = var.region_jenkins
  availability_zone = var.availability_zone_jenkins
  env               = var.env_jenkins
  instance_type     = var.instance_type_jenkins
  vpc_cidr_jenkins  = var.vpc_cidr_jenkins
  pub_a             = var.pub_a_jenkins
  pub_b             = var.pub_b_jenkins
  pvt_a             = var.pvt_a_jenkins
  pvt_b             = var.pvt_b_jenkins
  ssh_key_name      = var.ssh_key_name 
  udata_jmaster     = file("${path.module}/${var.udata_jmaster}")
  udata_jslave      = file("${path.module}/${var.udata_jslave}")
}


#################
# Route53
#################

resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "ns_record" {
  allow_overwrite = true
  name            = var.domain_name
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.main.zone_id

  records = [
    aws_route53_zone.main.name_servers[0],
    aws_route53_zone.main.name_servers[1],
    aws_route53_zone.main.name_servers[2],
    aws_route53_zone.main.name_servers[3],
  ]
}



#################
# dev
#################
module "dev"{
  source  = "./modules/app"

  ###################
  # Network variables
  ###################
  region                                   = var.region_dev  
  env                                      = var.env_dev
  domain_name                              = var.domain_name
  zone_name                                = "${var.env_dev}.${aws_route53_zone.main.name}"
  zone_id                                  = aws_route53_zone.main.zone_id
  hosted_zone_id                           = aws_route53_zone.main.zone_id
  create_certificate                       = var.create_certificate_dev
  wait_for_validation                      = var.wait_for_validation_dev

  #################
  # ALB
  #################
  alb_name                                 = var.alb_name_dev
  load_balancer_type                       = var.load_balancer_type 
  backend_protocol                         = var.backend_protocol
  backend_port                             = var.backend_port
  target_type                              = var.target_type
  interval_for_alb                         = var.interval_for_alb 
  healthy_threshold                        = var.healthy_threshold 
  unhealthy_threshold                      = var.unhealthy_threshold
  timeout_for_alb                          = var.timeout_for_alb
  protocol_for_alb                         = var.protocol_for_alb 
  matcher_for_alb                          = var.matcher_for_alb
  http_tcp_listeners_port                  = var.http_tcp_listeners_port
  http_tcp_listeners_protocol              = var.http_tcp_listeners_protocol
  http_tcp_listeners_target_group_index    = var.http_tcp_listeners_target_group_index  

  #################
  # ASG
  #################

  name_for_web_instances                     = var.name_for_web_instances 
  lc_name_for_web_asg                        = var.lc_name_for_web_asg
  instance_type_for_web_asg                  = var.instance_type_for_web_asg
  volume_size_for_web_asg                    = var.volume_size_for_web_asg 
  volume_type_for_web_asg                    = var.volume_type_for_web_asg 
  asg_name_web                               = var.asg_name_web
  health_check_type_for_web                  = var.health_check_type_for_web
  min_size_for_web                           = var.min_size_for_web 
  max_size_for_web                           = var.max_size_for_web
  desired_capacity_for_web                   = var.desired_capacity_for_web 
  wait_for_capacity_timeout_for_web          = var.wait_for_capacity_timeout_for_web
  udata_asg                                  = file("${path.module}/${var.udata_dev}")
  

  #################
  # Network
  #################
  instance_type                              = var.instance_type_dev
  vpc_cidr                                   = var.vpc_cidr_dev
  pub_a                                      = var.pub_a_dev
  pub_b                                      = var.pub_b_dev
  pvt_a                                      = var.pvt_a_dev
  pvt_b                                      = var.pvt_b_dev
  ssh_key_name                               = var.ssh_key_name 
  

  #################
  # Database
  #################
  db_identifier                             = var.db_identifier_dev
  db_engine                                 = var.db_engine_dev
  db_engine_version                         = var.db_engine_version_dev
  db_family                                 = var.db_family_dev
  db_major_engine_version                   = var.db_major_engine_version_dev
  db_instance_class                         = var.db_instance_class_dev
  db_allocated_storage                      = var.db_allocated_storage_dev
  db_max_allocated_storage                  = var.db_max_allocated_storage_dev
  db_storage_encrypted                      = var.db_storage_encrypted_dev 
  db_name                                   = var.db_name_dev 
  db_username                               = var.db_username_dev
  db_password                               = var.db_password_dev  
  db_port                                   = var.db_port_dev
  db_multi_az                               = var.db_multi_az_dev 
  db_maintenance_window                     = var.db_maintenance_window_dev
  db_backup_window                          = var.db_backup_window_dev 
  db_enabled_cloudwatch_logs_exports        = var.db_enabled_cloudwatch_logs_exports_dev
  db_backup_retention_period                = var.db_backup_retention_period_dev 
  db_skip_final_snapshot                    = var.db_skip_final_snapshot_dev 
  db_deletion_protection                    = var.db_deletion_protection_dev
  db_performance_insights_enabled           = var.db_performance_insights_enabled_dev 
  db_performance_insights_retention_period  = var.db_performance_insights_retention_period_dev 
  db_create_monitoring_role                 = var.db_create_monitoring_role_dev
  db_monitoring_interval                    = var.db_monitoring_interval_dev 
  db_monitoring_role_name                   = var.db_monitoring_role_name_dev
  db_monitoring_role_description            = var.db_monitoring_role_description_dev 

}




#################
# prod
#################

module "prod"{
  source  = "./modules/app"
  region                                   = var.region_prod  
  env                                      = var.env_prod
  domain_name                              = var.domain_name
  zone_name                                = "${var.env_prod}.${aws_route53_zone.main.name}"
  zone_id                                  = aws_route53_zone.main.zone_id
  hosted_zone_id                           = aws_route53_zone.main.zone_id
  create_certificate                       = var.create_certificate_prod
  wait_for_validation                      = var.wait_for_validation_prod

  #################
  # ALB
  #################
  alb_name                                 = var.alb_name_prod  
  load_balancer_type                       = var.load_balancer_type 
  backend_protocol                         = var.backend_protocol
  backend_port                             = var.backend_port
  target_type                              = var.target_type
  interval_for_alb                         = var.interval_for_alb 
  healthy_threshold                        = var.healthy_threshold 
  unhealthy_threshold                      = var.unhealthy_threshold
  timeout_for_alb                          = var.timeout_for_alb
  protocol_for_alb                         = var.protocol_for_alb 
  matcher_for_alb                          = var.matcher_for_alb
  http_tcp_listeners_port                  = var.http_tcp_listeners_port
  http_tcp_listeners_protocol              = var.http_tcp_listeners_protocol
  http_tcp_listeners_target_group_index    = var.http_tcp_listeners_target_group_index 

  #################
  # ASG
  #################

  name_for_web_instances                     = var.name_for_web_instances 
  lc_name_for_web_asg                        = var.lc_name_for_web_asg
  instance_type_for_web_asg                  = var.instance_type_for_web_asg
  volume_size_for_web_asg                    = var.volume_size_for_web_asg 
  volume_type_for_web_asg                    = var.volume_type_for_web_asg 
  asg_name_web                               = var.asg_name_web
  health_check_type_for_web                  = var.health_check_type_for_web
  min_size_for_web                           = var.min_size_for_web 
  max_size_for_web                           = var.max_size_for_web
  desired_capacity_for_web                   = var.desired_capacity_for_web 
  wait_for_capacity_timeout_for_web          = var.wait_for_capacity_timeout_for_web
  udata_asg                                  = file("${path.module}/${var.udata_prod}")
  
  
  #################
  # Network
  #################
  instance_type                            = var.instance_type_prod
  vpc_cidr                                 = var.vpc_cidr_prod
  pub_a                                    = var.pub_a_prod
  pub_b                                    = var.pub_b_prod
  pvt_a                                    = var.pvt_a_prod
  pvt_b                                    = var.pvt_b_prod
  ssh_key_name                             = var.ssh_key_name 
  

  #################
  # Database
  #################
  db_identifier                             = var.db_identifier_prod
  db_engine                                 = var.db_engine_prod
  db_engine_version                         = var.db_engine_version_prod
  db_family                                 = var.db_family_prod
  db_major_engine_version                   = var.db_major_engine_version_prod
  db_instance_class                         = var.db_instance_class_prod
  db_allocated_storage                      = var.db_allocated_storage_prod
  db_max_allocated_storage                  = var.db_max_allocated_storage_prod
  db_storage_encrypted                      = var.db_storage_encrypted_prod 
  db_name                                   = var.db_name_prod 
  db_username                               = var.db_username_prod
  db_password                               = var.db_password_prod  
  db_port                                   = var.db_port_prod
  db_multi_az                               = var.db_multi_az_prod 
  db_maintenance_window                     = var.db_maintenance_window_prod 
  db_backup_window                          = var.db_backup_window_prod 
  db_enabled_cloudwatch_logs_exports        = var.db_enabled_cloudwatch_logs_exports_prod
  db_backup_retention_period                = var.db_backup_retention_period_prod 
  db_skip_final_snapshot                    = var.db_skip_final_snapshot_prod 
  db_deletion_protection                    = var.db_deletion_protection_prod
  db_performance_insights_enabled           = var.db_performance_insights_enabled_prod 
  db_performance_insights_retention_period  = var.db_performance_insights_retention_period_prod 
  db_create_monitoring_role                 = var.db_create_monitoring_role_prod
  db_monitoring_interval                    = var.db_monitoring_interval_prod 
  db_monitoring_role_name                   = var.db_monitoring_role_name_prod
  db_monitoring_role_description            = var.db_monitoring_role_description_prod 
}


#################
# Peering Connection
#################

/*resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}*/

resource "aws_vpc" "peer_dev" {
  provider   = aws.peer
  cidr_block = var.peer_cidr_block_dev
}

data "aws_caller_identity" "peer_dev" {
  provider = aws.peer
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "peer_dev" {
  vpc_id        = module.jenkins.vpc_id                                  #aws_vpc.main.id #!!!
  peer_vpc_id   = aws_vpc.peer_dev.id
  peer_owner_id = data.aws_caller_identity.peer_dev.account_id
  peer_region   = var.region_peer
  auto_accept   = false

  tags = {
    Side = "Requester"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer_dev" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_dev.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

resource "aws_vpc" "peer_prod" {
  provider   = aws.peer
  cidr_block = var.peer_cidr_block_prod
}

data "aws_caller_identity" "peer_prod" {
  provider = aws.peer
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "peer_prod" {
  vpc_id        = module.jenkins.vpc_id                                  #aws_vpc.main.id #!!!
  peer_vpc_id   = aws_vpc.peer_prod.id
  peer_owner_id = data.aws_caller_identity.peer_prod.account_id
  peer_region   = var.region_peer
  auto_accept   = false

  tags = {
    Side = "Requester"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer_prod" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_prod.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}













































/*module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2"

  name = local.name
  cidr = "10.99.0.0/18"

  azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets   = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
  private_subnets  = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]
  database_subnets = ["10.99.7.0/24", "10.99.8.0/24", "10.99.9.0/24"]

  create_database_subnet_group = true

  tags = local.tags
}

module "vpc" {
    source  = "terraform-google-modules/network/google//modules/subnets"
    version = "~> 2.0.0"

    project_id   = "<PROJECT ID>"
    network_name = "example-vpc"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-west1"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "This subnet has a description"
        },
        {
            subnet_name               = "subnet-03"
            subnet_ip                 = "10.10.30.0/24"
            subnet_region             = "us-west1"
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_10_MIN"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        }
    ]

    secondary_ranges = {
        subnet-01 = [
            {
                range_name    = "subnet-01-secondary-01"
                ip_cidr_range = "192.168.64.0/24"
            },
        ]

        subnet-02 = []
    }
}


module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

  ingress_cidr_blocks      = ["10.10.0.0/16"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}




resource "aws_instance" "aws-instance" {
    ami           = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    availability_zone = "${var.availability_zone}"
    associate_public_ip_address = true
    security_groups = ["${aws_security_group.aws-security-group.name}"]


    #tags {
     # Name = "${var.name}"
      #Environment = "${var.env}"
      #CreatedBy = "terraform"
    #}
    
    provisioner "remote-exec" {
      # The connection will use the local SSH agent for authentication
      inline = ["echo Successfully connected"]

      # The connection block tells our provisioner how to communicate with the resource (instance)
      connection {
        user = "${local.vm_user}"
        host     = coalesce(self.public_ip, self.private_ip)
      }
    }
    provisioner "local-exec" {
      command = <<EOT
        echo [defaults] > ansible.cfg;
        echo hostfile = inventory-${var.env} >> ansible.cfg;
        echo host_key_checking = False >> ansible.cfg;
        echo #private_key_file = ~/amazon/jijeesh/${var.key_name}.pem >> ansible.cfg;
        echo deprecation_warnings=False >> ansible.cfg;
        echo #gathering = smart >> ansible.cfg;
        echo #fact_caching = jsonfile >> ansible.cfg;
        echo #fact_caching_connection = /tmp/facts_cache >> ansible.cfg;
        echo #fact_caching_timeout = 7200 >> ansible.cfg;
        echo forks = 100 >> ansible.cfg;
        echo bin_ansible_callbacks=True >> ansible.cfg;
        echo connection_plugins = ../ansible/connection_plugins >> ansible.cfg;
        echo [ssh_connection] >> ansible.cfg;
        echo pipelining = True >> ansible.cfg;
        echo control_path = /tmp/ansible-ssh-%%h-%%p-%%r >> ansible.cfg;
        echo [${var.env}] > inventory-${var.env};
        echo ${aws_instance.aws-instance.public_ip} ansible_python_interpreter=/usr/bin/python3 >> inventory-${var.env};
        ansible-playbook -s main.yml
        EOT
      on_failure = "continue"
    }



    # This is where we configure the instance with ansible-playbook

    provisioner "local-exec" {

      #command = "echo ${aws_instance.jenkins_master.public_ip} >> ${var.env}"
        # command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${local.vm_user}  -i '${aws_instance.aws-instance.public_ip},' -e 'ansible_python_interpreter=/usr/bin/python3' master.yml"
        command = "ansible-playbook -s main.yml"
    }
}

output "public_ip" {
  value = "${aws_instance.aws-instance.public_ip}"
}*/



/*resource "aws_instance" "jenkins" {
  instance_type = "${var.instance_type}"
  ami = "${var.ami}"
  key_name = "${var.key_name}"

  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["sg_jenkins"]

  iam_instance_profile = "${var.iam_instance_profile}"

  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "${var.vm_user}"
    host     = coalesce(self.public_ip, self.private_ip)
    # The connection will use the local SSH agent for authentication.
  }

  #tags {
  #  Name = "${var.jenkins_name}"
  #}

  # force Terraform to wait until a connection can be made, so that Ansible doesn't fail when trying to provision
  provisioner "remote-exec" {
    inline = [
      "echo 'Remote execution connected.'"
    ]
  }
}*/
