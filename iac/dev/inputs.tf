#database variables

variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "11.10"
}

variable "db_family" {
  description = "Database engine"
  type        = string
  default     = "postgres11"
}

variable "db_major_engine_version" {
  description = "Database major engine version"
  type        = string
  default     = "11"
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t2.micro"   #db.t3.large
}

variable "db_allocated_storage" {
  description = "Database allocated_storage"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Database max allocated storage"
  type        = number
  default     = 100
}

variable "db_storage_encrypted" {
  description = "Database storage encryption"
  type        = bool
  default     = true
}

variable "db_name" {
  description = "Database "
  type        = string
  default     = "completePostgresql"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "complete_postgresql"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "YourPwdShouldBeLongAndSecure!"
}

variable "db_port" {
  description = "Database engine"
  type        = number
  default     = 5432
}

variable "db_multi_az" {
  description = "Database multiavailability zone"
  type        = bool
  default     = true
}

variable "db_maintenance_window" {
  description = "Database maintenance window"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "db_backup_window" {
  description = "Database backup window"
  type        = string
  default     = "03:00-06:00"
}

variable "db_enabled_cloudwatch_logs_exports" {
  description = "Database enabled cloudwatch logs exports"
  type        = list
  default     = ["postgresql", "upgrade"]
}

variable "db_backup_retention_period" {
  description = "Database backup retentionperiod"
  type        = number
  default     = 0
}


variable "db_skip_final_snapshot" {
  description = "Database skip final snapshot"
  type        = bool
  default     = true
}

variable "db_deletion_protection" {
  description = "Database deletion protection"
  type        = bool
  default     = false
}

variable "db_performance_insights_enabled" {
  description = "Database performance insights enabled"
  type        = bool
  default     = true
}

variable "db_performance_insights_retention_period" {
  description = "Database performance insights retention period"
  type        = number
  default     = 7
}

variable "db_create_monitoring_role" {
  description = "Database performance insights enabled"
  type        = bool
  default     = true
}

variable "db_monitoring_interval " {
  description = "Database monitoringinterval "
  type        = number
  default     = 60
}

variable "db_monitoring_role_name" {
  description = "Database monitoring_role_name"
  type        = string
  default     = "example-monitoring-role-name"
}

variable "db_monitoring_role_description" {
  description = "Database monitoring role description"
  type        = string
  default     = "Description for monitoring role"
}






