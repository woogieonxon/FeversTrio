variable "db_name" {
  description = "The name of the database to create"
  type        = string
}

variable "db_user" {
  description = "Username for the database administrator"
  type        = string
}

variable "db_password" {
  description = "Password for the database administrator"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "The instance class to use for the database instance"
  type        = string
  default     = "db.r4.large"
}

variable "vpc_id" {
  description = "The VPC ID where the database should be created"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs to use in the database subnet group"
  type        = list(string)
}
