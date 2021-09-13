terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"      
      version = "~> 3.57"
    }
  }

  
  required_version = ">= 1.0.4"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}


locals {
  name   = "complete-postgresql"
  region = "us-east-2"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

#Route 53

module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
    "terraform-aws-modules-example.com" = {
      comment = "terraform-aws-modules-examples.com (production)"
      tags = {
        env = "production"
      }
    }

    "myapp.com" = {
      comment = "myapp.com"
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
      name    = "apigateway1"
      type    = "A"
      alias   = {
        name    = "d-10qxlbvagl.execute-api.eu-west-1.amazonaws.com"
        zone_id = "ZLY8HYME6SFAD"
      }
    },
    {
      name    = ""
      type    = "A"
      ttl     = 3600
      records = [
        "10.10.10.10",
      ]
    },
  ]

  depends_on = [module.zones]
}

#peering connection

resource "aws_vpc_peering_connection" "foo" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.bar.id
  vpc_id        = aws_vpc.foo.id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between foo and bar"
  }
}

resource "aws_vpc" "foo" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_vpc" "bar" {
  cidr_block = "10.2.0.0/16"
}



module "bastion" {
  source = "Guimove/bastion/aws"
  bucket_name = "my_famous_bucket_name"
  region = "eu-west-1"
  vpc_id = "my_vpc_id"
  is_lb_private = "true|false"
  bastion_host_key_pair = "my_key_pair"
  create_dns_record = "true|false"
  hosted_zone_id = "my.hosted.zone.name."
  bastion_record_name = "bastion.my.hosted.zone.name."
  bastion_iam_policy_name = "myBastionHostPolicy"
  elb_subnets = [
    "subnet-id1a",
    "subnet-id1b"
  ]
  auto_scaling_group_subnets = [
    subnet-id1a,
    subnet-id1b
  ]
  tags = {
    name = "my_bastion_name",
    description = "my_bastion_description"
  }
}




################################################################################
# Supporting Resources
################################################################################

module "vpc" {
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

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name        = local.name
  description = "Complete PostgreSQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = local.tags
}

################################################################################
# RDS Module
################################################################################

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.name

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "11.10"
  family               = "postgres11" # DB parameter group
  major_engine_version = "11"         # DB option group
  instance_class       = "db.t3.large"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = false

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  name     = "completePostgresql"
  username = "complete_postgresql"
  password = "YourPwdShouldBeLongAndSecure!"
  port     = 5432

  multi_az               = true
  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_name                  = "example-monitoring-role-name"
  monitoring_role_description           = "Description for monitoring role"

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  tags = local.tags
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  db_subnet_group_tags = {
    "Sensitive" = "high"
  }
}


/*module "db_default" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${local.name}-default"

  create_db_option_group    = false
  create_db_parameter_group = false

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "11.10"
  family               = "postgres11" # DB parameter group
  major_engine_version = "11"         # DB option group
  instance_class       = "db.t3.large"

  allocated_storage = 20

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  name                   = "completePostgresql"
  username               = "complete_postgresql"
  create_random_password = true
  random_password_length = 12
  port                   = 5432

  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 0

  tags = local.tags
}

module "db_disabled" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${local.name}-disabled"

  create_db_instance        = false
  create_db_subnet_group    = false
  create_db_parameter_group = false
  create_db_option_group    = false
}*/


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id             = "vpc-abcde012"
  subnets            = ["subnet-abcde012", "subnet-bcde012a"]
  security_groups    = ["sg-edcd9784", "sg-edcd9785"]

  access_logs = {
    bucket = "my-alb-logs"
  }

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = "i-0123456789abcdefg"
          port = 80
        },
        {
          target_id = "i-a1b2c3d4e5f6g7h8i"
          port = 8080
        }
      ]
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}



############################################################################################
############################################################################################
# Create a new load balancer
/*resource "aws_elb" "bar" {
  name               = "foobar-terraform-elb"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  access_logs {
    bucket        = "foo"
    bucket_prefix = "bar"
    interval      = 60
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = [aws_instance.foo.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
}*/






############################################################################################

#bastion host

/*resource "aws_vpc_peering_connection" "foo" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = aws_vpc.bar.id
  vpc_id        = aws_vpc.foo.id
  peer_region   = "us-east-1"
}

resource "aws_vpc" "foo" {
  provider   = aws.us-west-2
  cidr_block = "10.1.0.0/16"
}

resource "aws_vpc" "bar" {
  provider   = aws.us-east-1
  cidr_block = "10.2.0.0/16"
}*/



/*resource "aws_instance" "web" {
  ami           = "ami-0d563aeddd4be7fff"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
  
  key_name = "vieskovtf"
}*/

/*module "bastion" {
  source = "Guimove/bastion/aws"
  bucket_name = "my_famous_bucket_name"
  region = "eu-west-1"
  vpc_id = "my_vpc_id"
  is_lb_private = "true|false"
  bastion_host_key_pair = "my_key_pair"
  create_dns_record = "true|false"
  hosted_zone_id = "my.hosted.zone.name."
  bastion_record_name = "bastion.my.hosted.zone.name."
  bastion_iam_policy_name = "myBastionHostPolicy"
  elb_subnets = [
    "subnet-id1a",
    "subnet-id1b"
  ]
  auto_scaling_group_subnets = [
    subnet-id1a,
    subnet-id1b
  ]
  tags = {
    name = "my_bastion_name",
    description = "my_bastion_description"
  }
}*/

/*module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.25.0"

  cidr_block = "172.16.0.0/16"

  context = module.this.context
}*/

/*module "subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "0.39.3"
  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "aws_key_pair" {
  source              = "cloudposse/key-pair/aws"
  version             = "0.18.0"
  attributes          = ["ssh", "key"]
  ssh_public_key_path = var.ssh_key_path
  generate_ssh_key    = var.generate_ssh_key

  context = module.this.context
}*/

/*module "ec2_bastion" {
  #source = "../../"
  source = "cloudposse/terraform-aws-ec2-instance/aws"
  enabled = module.this.enabled

  instance_type               = var.instance_type
  security_groups             = compact(concat([module.vpc.vpc_default_security_group_id], var.security_groups))
  subnets                     = module.subnets.public_subnet_ids
  key_name                    = module.aws_key_pair.key_name
  user_data                   = var.user_data
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = var.associate_public_ip_address

  context = module.this.context
}*/

/*module "instance" {
  source = "cloudposse/ec2-instance/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  ssh_key_pair                = var.ssh_key_pair
  instance_type               = var.instance_type
  vpc_id                      = var.vpc_id
  security_groups             = var.security_groups
  subnet                      = var.subnet
  name                        = "ec2"
  namespace                   = "eg"
  stage                       = "dev"
}*/


/*module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id             = "vpc-abcde012"
  subnets            = ["subnet-abcde012", "subnet-bcde012a"]
  security_groups    = ["sg-edcd9784", "sg-edcd9785"]

  access_logs = {
    bucket = "my-alb-logs"
  }

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = "i-0123456789abcdefg"
          port = 80
        },
        {
          target_id = "i-a1b2c3d4e5f6g7h8i"
          port = 8080
        }
      ]
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

resource "aws_db_instance" "example" {
  # ... other configuration ...

  allocated_storage     = 50
  max_allocated_storage = 100
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "demodb"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.large"
  allocated_storage = 5

  name     = "demodb"
  username = "user"
  password = "YourPwdShouldBeLongAndSecure!"
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["sg-12345678"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval = "30"
  monitoring_role_name = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids = ["subnet-12345678", "subnet-87654321"]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}*/

/*module "postgresql_rds" {
  source = "github.com/azavea/terraform-aws-postgresql-rds"
  vpc_id = "vpc-20f74844"
  allocated_storage = "32"
  engine_version = "9.4.4"
  instance_type = "db.t2.micro"
  storage_type = "gp2"
  database_identifier = "jl23kj32sdf"
  database_name = "hector"
  database_username = "hector"
  database_password = "secret"
  database_port = "5432"
  backup_retention_period = "30"
  backup_window = "04:00-04:30"
  maintenance_window = "sun:04:30-sun:05:30"
  auto_minor_version_upgrade = false
  multi_availability_zone = true
  storage_encrypted = false
  subnet_group = aws_db_subnet_group.default.name
  parameter_group = aws_db_parameter_group.default.name
  monitoring_interval = "60"
  deletion_protection = true
  cloudwatch_logs_exports = ["postgresql"]

  alarm_cpu_threshold = "75"
  alarm_disk_queue_threshold = "10"
  alarm_free_disk_threshold = "5000000000"
  alarm_free_memory_threshold = "128000000"
  alarm_actions = ["arn:aws:sns..."]
  ok_actions = ["arn:aws:sns..."]
  insufficient_data_actions = ["arn:aws:sns..."]

  project = "Something"
  environment = "Staging"
}*/

/*module "ec2_instance" {
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


module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = "10.0.0.0/8"
  networks = [
    {
      name     = "foo"
      new_bits = 8
    },
    {
      name     = "bar"
      new_bits = 8
    },
    {
      name     = "baz"
      new_bits = 4
    },
    {
      name     = "beep"
      new_bits = 8
    },
    {
      name     = "boop"
      new_bits = 8
    },
  ]
}*/

/*Private Subnet

  module "subnets" {
    source              = "clouddrove/terraform-aws-subnet/aws"
    version             = "0.15.0"
    name                = "subnets"
    environment         = "test"
    label_order         = ["name", "environment"]
    availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    vpc_id              = "vpc-xxxxxxxxx"
    type                = "private"
    nat_gateway_enabled = true
    cidr_block          = "10.0.0.0/16"
    ipv6_cidr_block     = module.vpc.ipv6_cidr_block
    public_subnet_ids   = ["subnet-XXXXXXXXXXXXX", "subnet-XXXXXXXXXXXXX"]
  }

Public-Private Subnet

  module "subnets" {
    source              = "clouddrove/terraform-aws-subnet/aws"
    version             = "0.15.0"
    name                = "subnets"
    environment         = "test"
    label_order         = ["name", "environment"]
    availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    vpc_id              = "vpc-xxxxxxxxx"
    type                = "public-private"
    igw_id              = "ig-xxxxxxxxx"
    nat_gateway_enabled = true
    cidr_block          = "10.0.0.0/16"
    ipv6_cidr_block     = module.vpc.ipv6_cidr_block
  }

### Public-Private Subnet with single Nat Gateway

  module "subnets" {
    source              = "clouddrove/terraform-aws-subnet/aws"
    version             = "0.15.0"
    name                = "subnets"
    environment         = "test"
    label_order         = ["name", "environment"]
    availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    vpc_id              = "vpc-xxxxxxxxx"
    type                = "public-private"
    igw_id              = "ig-xxxxxxxxx"
    nat_gateway_enabled = true
    single_nat_gateway  = true
    cidr_block          = "10.0.0.0/16"
    ipv6_cidr_block     = module.vpc.ipv6_cidr_block
  }*/

/*Public Subnet

  module "subnets" {
    source              = "clouddrove/terraform-aws-subnet/aws"
    version             = "0.15.0"
    name                = "subnets"
    environment         = "test"
    label_order         = ["name", "environment"]
    availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
    vpc_id              = "vpc-xxxxxxxxx"
    type                = "public"
    igw_id              = "ig-xxxxxxxxx"
    cidr_block          = "10.0.0.0/16"
    ipv6_cidr_block     = module.vpc.ipv6_cidr_block
  }

Public-private-subnet-single-nat-gateway

  module "subnets" {
    source              = "clouddrove/terraform-aws-subnet/aws"
    version             = "0.15.0"
    nat_gateway_enabled = true
    single_nat_gateway  = true
    name                = "subnets"
    environment         = "example"
    label_order         = ["name", "environment"]
    availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    vpc_id              = "vpc-xxxxxxxxxx"
    type                = "public-private"
    igw_id              = "ig-xxxxxxxxxxx"
    cidr_block          = "10.0.0.0/16"
    ipv6_cidr_block     = module.vpc.ipv6_cidr_block
  }*/


  /*provider "postgresql" {
  host            = "postgres_server_ip"
  port            = 5432
  database        = "postgres"
  username        = "postgres_user"
  password        = "postgres_password"
  sslmode         = "require"
  connect_timeout = 15
}

An SSL client certificate can be configured using the clientcert sub-resource.

provider "postgresql" {
  host            = "postgres_server_ip"
  port            = 5432
  database        = "postgres"
  username        = "postgres_user"
  password        = "postgres_password"
  sslmode         = "require"
  clientcert {
    cert = "/path/to/public-certificate.pem"
    key  = "/path/to/private-key.pem"
  }

Configuring multiple servers can be done by specifying the alias option.

provider "postgresql" {
  alias    = "pg1"
  host     = "postgres_server_ip1"
  username = "postgres_user1"
  password = "postgres_password1"
}

provider "postgresql" {
  alias    = "pg2"
  host     = "postgres_server_ip2"
  username = "postgres_user2"
  password = "postgres_password2"
}

resource "postgresql_database" "my_db1" {
  provider = "postgresql.pg1"
  name     = "my_db1"
}

resource "postgresql_database" "my_db2" {
  provider = "postgresql.pg2"
  name     = "my_db2"
}*/

/*module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
    "terraform-aws-modules-example.com" = {
      comment = "terraform-aws-modules-examples.com (production)"
      tags = {
        env = "production"
      }
    }

    "myapp.com" = {
      comment = "myapp.com"
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
      name    = "apigateway1"
      type    = "A"
      alias   = {
        name    = "d-10qxlbvagl.execute-api.eu-west-1.amazonaws.com"
        zone_id = "ZLY8HYME6SFAD"
      }
    },
    {
      name    = ""
      type    = "A"
      ttl     = 3600
      records = [
        "10.10.10.10",
      ]
    },
  ]

  depends_on = [module.zones]
}*/

/*Public Hostedzone

  module "route53" {
    source        = "clouddrove/route53/aws"
    version       = "0.15.0"
    name           = "route53"
    application    = "clouddrove"
    environment    = "test"
    label_order    = ["environment", "name"]
    public_enabled = true
    record_enabled = true
    domain_name    = "clouddrove.com"
    names          = [
                      "www.",
                      "admin."
                    ]
    types          = [
                      "A",
                      "CNAME"
                    ]
    alias          = {
                      names = [
                        "d130easdflja734js.cloudfront.net"
                      ]
                      zone_ids = [
                        "Z2FDRFHATA1ER4"
                      ]
                      evaluate_target_healths = [
                        false
                      ]
                    }
  }

Private Hostedzone

  module "route53" {
    source        = "clouddrove/route53/aws"
    version       = "0.15.0"
    name            = "route53"
    application     = "clouddrove"
    environment     = "test"
    label_order     = ["environment", "name"]
    private_enabled = true
    record_enabled  = true
    domain_name     = "clouddrove.com"
    vpc_id          = "vpc-xxxxxxxxxxxxx"
    names           = [
                      "www.",
                      "admin."
                     ]
    types           = [
                      "A",
                      "CNAME"
                     ]
    ttls            = [
                      "3600",
                      "3600",
                     ]
    values          = [
                      "10.0.0.27",
                      "mydomain.com",
                     ]
  }

Vpc Association

  module "route53" {
    source        = "clouddrove/route53/aws"
    version       = "0.15.0"
    name                 = "route53"
    application          = "clouddrove"
    environment          = "test"
    label_order          = ["environment", "name"]
    private_enabled      = true
    enabled              = true
    domain_name          = "clouddrove.com"
    vpc_id               = "vpc-xxxxxxxxxxxxx"
    secondary_vpc_id     = "vpc-xxxxxxxxxxxxx"
    secondary_vpc_region = "eu-west-1"
  }*/

/*  Simple routing policy

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.example.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.lb.public_ip]
}*/

/*Weighted routing policy

Other routing policies are configured similarly. See AWS Route53 Developer Guide for details.

resource "aws_route53_record" "www-dev" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "dev"
  records        = ["dev.example.com"]
}

resource "aws_route53_record" "www-live" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 90
  }

  set_identifier = "live"
  records        = ["live.example.com"]
}*/

