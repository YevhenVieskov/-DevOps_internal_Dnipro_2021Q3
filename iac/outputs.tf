output "public_ip_jm" {
  description = "The public IP address assigned to the instance, if applicable."
  value       = module.jenkins.public_ip_jm
}

output "public_ip_js" {
  description = "The public IP address assigned to the instance, if applicable."
  value       = module.jenkins.public_ip_js
}

output "dev_lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.dev.lb_dns_name
}

output "dev_autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = module.dev.autoscaling_group_id
}

output "prod_lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.dev.lb_dns_name
}

output "prod_autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = module.dev.autoscaling_group_id
}



/*output "vpc_id" {
  description = "ID of the VPC"
  value       = module.jenkins.vpc_id
}

output "public_subnets" {
  description = "ID of the VPC public subnet"
  value       = module.jenkins.public_subnets
}

output "private_subnets" {
  description = "ID of the VPC private subnet"
  value       = module.jenkins.private_subnets
  }*/




  




/*output "sg_id" {
  value = module.bastion.security_group_id
}*/

// The domain name.
/*output "domain_name" {
  value = "${var.domain_name}"
}*/

// The zone ID.
/*output "zone_id" {
  value = "${aws_route53_zone.main.zone_id}"
}

// A comma separated list of the zone name servers.
output "name_servers" {
  value = "${join(",",aws_route53_zone.main.name_servers)}"
}*/