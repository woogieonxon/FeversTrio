variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
}

variable "storage_type" {
  description = "The type of storage to use"
  default     = "gp2"
}

variable "engine" {
  description = "The database engine to use"
}

variable "engine_version" {
  description = "The engine version to use"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
}

variable "username" {
  description = "Username for the database"
}

variable "password" {
  description = "Password for the database"
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}


variable "bastion_security_group_id" {
  description = "Security group ID for the bastion host"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the RDS instance will be created"
  type        = string
}

variable "identifier" {
  description = "The DB instance identifier"
  type        = string
}