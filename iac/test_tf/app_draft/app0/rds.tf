/*resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.this["pvt_a"].id, aws_subnet.this["pvt_b"].id]

  tags = merge(local.common_tags, { Name = "DB subnet group" })
}

private_subnets = [var.pvt_a, var.pvt_b]

module.vpc.private_subnets

resource "aws_db_instance" "web" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  availability_zone    = "${var.aws_region}a"
  skip_final_snapshot  = true

  db_subnet_group_name   = aws_db_subnet_group.default.id
  vpc_security_group_ids = [aws_security_group.db.id]
}*/


module "dbi" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "webdb"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.large"
  allocated_storage = 5

  name     = "webdb"
  username = "vieskovtf"
  password = "YourPwdShouldBeLongAndSecure!"
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.db.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval = "30"
  monitoring_role_name = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "vieskovtf"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids =  module.vpc.private_subnets #["subnet-12345678", "subnet-87654321"]

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
}
