/*data "aws_route53_zone" "vieskovtf" {
  name         = "vieskovtf.com"
  private_zone = false
}*/



resource "aws_route53_record" "env_record" {
  zone_id = var.zone_id
  name    = var.zone_name
  type    = "A"
  
  alias {
    name    = module.app_alb.lb_dns_name
    zone_id = module.app_alb.lb_zone_id
    evaluate_target_health = true
  }
}


module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name  = var.domain_name
  zone_id      = var.zone_id

  subject_alternative_names = [
    "*.${var.domain_name}",
    //"app.sub.my-domain.com",
  ]
  
  create_certificate = false
  wait_for_validation = true

  tags = {
    Name = var.domain_name
  }
}














/*module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
    "vieskovtf.com" = {
      comment = "vieskovtf.com"
      tags = {
        env = var.env
      }
    }
       
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = keys(module.zones.route53_zone_zone_id)[0]

  zone_id  =  module.zones.route53_zone_zone_id["vieskovtf.com"]

  records = [
    
    {
      name    =  "dev.vieskovtf.com"             #"zone-${var.zone_name}"
      type    = "A"
      #ttl     = 60
      alias   = {
        name    = module.app_alb.lb_dns_name
        zone_id = module.app_alb.lb_zone_id
      }
    },
  ]

  depends_on = [module.zones]              # , module.app_alb]
}*/


###################################################################################

/*resource "aws_route53_record" "bastion_record_name" {
  name    = var.bastion_record_name
  zone_id = var.hosted_zone_id
  type    = "A"
  count   = var.create_dns_record ? 1 : 0

  alias {
    evaluate_target_health = true
    name                   = aws_lb.bastion_lb.dns_name
    zone_id                = aws_lb.bastion_lb.zone_id
  }
}

resource "aws_route53_record" "nameservers" {
  allow_overwrite = true
  name            = "example.com"
  ttl             = 3600
  type            = "NS"
  zone_id         = aws_route53_zone.example.zone_id

  records = aws_route53_zone.example.name_servers
}


 {
      name           = "test"
      type           = "CNAME"
      ttl            = 5
      records        = ["test.example.com."]
      set_identifier = "test-primary"
      weighted_routing_policy = {
        weight = 90
      }

*/