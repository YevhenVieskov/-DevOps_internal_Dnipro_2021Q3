#################
# Route53
#################

resource "aws_route53_zone" "main2" {
  name = var.domain_name
}

resource "aws_route53_record" "ns_record2" {
  allow_overwrite = true
  name            = var.domain_name
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.main2.zone_id

  records = [
    aws_route53_zone.main2.name_servers[0],
    aws_route53_zone.main2.name_servers[1],
    aws_route53_zone.main2.name_servers[2],
    aws_route53_zone.main2.name_servers[3],
  ]
}




#################
# dev
#################
module "dev"{
  source  = "./app"
  
  ssh_key_name                            = var.ssh_key_name 
  region                                  = var.region

###################
###VPC variables###
###################
name_vpc                                  = var.name_vpc
vpc_cidr                                  = var.vpc_cidr 
pub_a                                     = var.pub_a 
pub_b                                     = var.pub_b 
pvt_a                                     = var.pvt_a
pvt_b                                     = var.pvt_b
env                                       = var.env_dev 
tags                                      = var.tags

##########################################
##Auto scaling groups bastion variables###
##########################################
name_for_bastion_instances                = var.name_for_bastion_instances 
lc_name_for_bastion_asg                   = var.lc_name_for_bastion_asg
instance_type_for_bastion_asg             = var.instance_type_for_bastion_asg
volume_size_for_bastion_asg               = var.volume_size_for_bastion_asg
volume_type_for_bastion_asg               = var.volume_type_for_bastion_asg
health_check_type_for_bastion             = var.health_check_type_for_bastion
min_size_for_bastion                      = var.min_size_for_bastion 
max_size_for_bastion                      = var.max_size_for_bastion
desired_capacity_for_bastion              = var.desired_capacity_for_bastion 
wait_for_capacity_timeout_for_bastion     = var.wait_for_capacity_timeout_for_bastion

###############################################
###Auto scaling groups web-servers variables###
###############################################
name_for_web_instances                    = var.name_for_web_instances
lc_name_for_web_asg                       = var.lc_name_for_web_asg 
instance_type_for_web_asg                 = var.instance_type_for_web_asg
volume_size_for_web_asg                   = var.volume_size_for_web_asg 
volume_type_for_web_asg                   = var.volume_type_for_web_asg 
asg_name_web                              = var.asg_name_web
health_check_type_for_web                 = var.health_check_type_for_web  
min_size_for_web                          = var.min_size_for_web 
max_size_for_web                          = var.max_size_for_web 
desired_capacity_for_web                  = var.desired_capacity_for_web 
wait_for_capacity_timeout_for_web         = var.wait_for_capacity_timeout_for_web

###############################
###Application Load Balancer###
###############################
alb_name                                  = var.alb_name
load_balancer_type                        = var.load_balancer_type 
backend_protocol                          = var.backend_protocol 
backend_port                              = var.backend_port
target_type                               = var.target_type 
interval_for_alb                          = var.interval_for_alb  
healthy_threshold                         = var.healthy_threshold 
unhealthy_threshold                       = var.unhealthy_threshold 
timeout_for_alb                           = var.timeout_for_alb 
protocol_for_alb                          = var.protocol_for_alb 
matcher_for_alb                           = var.matcher_for_alb
http_tcp_listeners_port                   = var.http_tcp_listeners_port 
http_tcp_listeners_protocol               = var.http_tcp_listeners_protocol
http_tcp_listeners_target_group_index     = var.http_tcp_listeners_target_group_index

#################
# User Data
#################
udata_asg                                 = file("${path.module}/${var.udata_dev}")

#################
# Route 53
#################
domain_name                               = var.domain_name
zone_name                                 = "${var.env_dev}.${aws_route53_zone.main2.name}"
zone_id                                   = aws_route53_zone.main2.zone_id
hosted_zone_id                            = aws_route53_zone.main2.zone_id
create_certificate                        = var.create_certificate 
wait_for_validation                       = var.wait_for_validation
ssl_certificate_id                        = var.ssl_certificate_id

#################
# Database
#################
db_identifier                             = var.db_identifier
db_engine                                 = var.db_engine
db_engine_version                         = var.db_engine_version
db_family                                 = var.db_family
db_major_engine_version                   = var.db_major_engine_version
db_instance_class                         = var.db_instance_class
db_allocated_storage                      = var.db_allocated_storage
db_max_allocated_storage                  = var.db_max_allocated_storage
db_storage_encrypted                      = var.db_storage_encrypted 
db_name                                   = var.db_name 
db_username                               = var.db_username
db_password                               = var.db_password  
db_port                                   = var.db_port
db_multi_az                               = var.db_multi_az 
db_maintenance_window                     = var.db_maintenance_window 
db_backup_window                          = var.db_backup_window 
db_enabled_cloudwatch_logs_exports        = var.db_enabled_cloudwatch_logs_exports
db_backup_retention_period                = var.db_backup_retention_period 
db_skip_final_snapshot                    = var.db_skip_final_snapshot 
db_deletion_protection                    = var.db_deletion_protection
db_performance_insights_enabled           = var.db_performance_insights_enabled 
db_performance_insights_retention_period  = var.db_performance_insights_retention_period 
db_create_monitoring_role                 = var.db_create_monitoring_role
db_monitoring_interval                    = var.db_monitoring_interval 
db_monitoring_role_name                   = var.db_monitoring_role_name
db_monitoring_role_description            = var.db_monitoring_role_description 



}

