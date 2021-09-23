

################################################################################
# RDS Module
################################################################################

module "dbi" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.db_identifier }${var.env}"

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  family               = var.db_family # DB parameter group
  major_engine_version = var.db_major_engine_version         # DB option group
  instance_class       = var.db_instance_class

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_encrypted     = var.db_storage_encrypted

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  name     = "${var.db_name}${var.env}"
  username = var.db_username
  password = var.db_password
  port     = 5432

  multi_az               = var.db_multi_az
  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [module.db.security_group_id]

  maintenance_window              = var.db_maintenance_window 
  backup_window                   = var.db_backup_window
  enabled_cloudwatch_logs_exports =  var.db_enabled_cloudwatch_logs_exports

  backup_retention_period = var.db_backup_retention_period
  skip_final_snapshot     = var.db_skip_final_snapshot
  deletion_protection     = var.db_deletion_protection

  performance_insights_enabled          = var.db_performance_insights_enabled
  performance_insights_retention_period = var.db_performance_insights_retention_period
  create_monitoring_role                = var.db_create_monitoring_role
  monitoring_interval                   = var.db_monitoring_interval
  monitoring_role_name                  = "${var.db_monitoring_role_name}-${var.env}" 
  monitoring_role_description           = var.db_monitoring_role_description

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

  tags = var.tags
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







