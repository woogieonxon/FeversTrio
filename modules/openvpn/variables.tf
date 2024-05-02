variable "instance_type" {
  description = "EC2 instance type for the OpenVPN server"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name to access EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the OpenVPN server"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the OpenVPN server will be deployed"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for security group creation"
  type        = string
}
