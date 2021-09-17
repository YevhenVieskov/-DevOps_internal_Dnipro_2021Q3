module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
    "${var.zone_name}" = {
      comment = var.zone_name
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

  records = [
    
    {
      name    =  module.app_alb.lb_id             #"zone-${var.zone_name}"
      type    = "A"
      ttl     = 3600
      alias   = {
        name    = module.app_alb.lb_dns_name
        zone_id = module.app_alb.lb_zone_id
      }
    },
  ]

  depends_on = [module.zones, module.app_alb]
}


###################################################################################

/*resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.example.zone_id
}*/