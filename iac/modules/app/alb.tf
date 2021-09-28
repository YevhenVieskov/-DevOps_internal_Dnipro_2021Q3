module "app_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = var.alb_name

  load_balancer_type = var.load_balancer_type

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.alb.security_group_id]

  /*access_logs = {
    bucket = "my-alb-logs"
  }*/

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = var.backend_protocol
      backend_port     = var.backend_port
      target_type      = var.target_type
      /*targets = [
        {
          target_id = module.bastion.autoscaling_group_id
          port = 80
        },
        {
          target_id = module.bastion.autoscaling_group_id     #module.asg.autoscaling_group_id
          port = 8080
        }
      ]*/
      health_check = {
        enabled             = true
        interval            = var.interval_for_alb
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = var.healthy_threshold
        unhealthy_threshold = var.unhealthy_threshold
        timeout             = var.timeout_for_alb
        protocol            = var.protocol_for_alb
        matcher             = var.matcher_for_alb
      }
    }
  ]

  /*https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    =  module.acm.acm_certificate_arn //var.ssl_certificate_id #"arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
      target_group_index = 0
    }
  ]*/

    http_tcp_listeners = [
    {
      port               = var.http_tcp_listeners_port
      protocol           = var.http_tcp_listeners_protocol
      target_group_index = var.http_tcp_listeners_target_group_index
    },


    /*{
      port               = var.im_docker_listeners_port
      protocol           = var.http_tcp_listeners_protocol
      target_group_index = var.http_tcp_listeners_target_group_index
    },*/


  ]

  tags = {
    Environment = var.env
  }
}