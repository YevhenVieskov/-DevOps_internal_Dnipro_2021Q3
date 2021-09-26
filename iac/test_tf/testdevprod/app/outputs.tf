/*output "alb_dns_name" {
  value = module.alb.this_lb_dns_name
}

output "alb_zone_id" {
  value = module.alb.this_lb_zone_id
}*/

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.this_lb_dns_name
}

output "lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = module.alb.this_lb_zone_id
}