module "app_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = var.alb_name

  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  security_groups    = [module.jenkins_master_sg.security_group_id, module.jenkins_slave_sg.security_group_id]

  /*access_logs = {
    bucket = "my-alb-logs"
  }*/

  target_groups = [

    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"      
    },

    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"      
    },


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
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },

    {
      port               = 8080
      protocol           = "HTTP"
      target_group_index = 0
    },


  ]

  tags = {
    Environment = var.env
  }
}