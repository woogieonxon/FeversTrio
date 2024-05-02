variable "ami_id" {
  description = "The AMI ID to use for the bastion host"
  type        = string

}

variable "instance_type" {
  description = "The instance type of the bastion host"
  type        = string
}

variable "key_name" {
  description = "The key name to use for the bastion host"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to launch the bastion host in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to create the security group within"
  type        = string
}

variable "name" {
  description = "The name to assign to the resources"
  type        = string
}

variable "allowed_cidr" {
  description = "The CIDR blocks allowed to access the bastion host"
  type        = list(string)
}

variable "root_volume_size" {
  description = "The size of the root volume in GiB"
  type        = number
  default     = 8 # 기본값 8GiB
}
