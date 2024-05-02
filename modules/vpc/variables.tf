variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_web_subnets_cidrs" {
  description = "A list of CIDR blocks for the private web subnets."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_db_subnets_cidrs" {
  description = "A list of CIDR blocks for the private database subnets."
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  description = "A list of availability zones in which to create subnets."
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}


# 추가적으로 필요한 변수들
variable "local_cluster_name" {
  description = "The name of the local Kubernetes cluster"
  type        = string
  default     = "woogie-cluster"
}

variable "private_subnets" {
  description = "A list of IDs for the private subnets"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of IDs for the public subnets"
  type        = list(string)
  default     = []
}