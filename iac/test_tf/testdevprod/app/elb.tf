module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = var.alb_name

  load_balancer_type = var.load_balancer_type

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb-sg.security_group_id]

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = var.backend_protocol
      backend_port     = var.backend_port
      target_type      = var.target_type
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

  http_tcp_listeners = [
    {
      port               = var.http_tcp_listeners_port
      protocol           = var.http_tcp_listeners_protocol
      target_group_index = var.http_tcp_listeners_target_group_index
    }
  ]

  tags = {
    Environment = "Test"
  }
}
