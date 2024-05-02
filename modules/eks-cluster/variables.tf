variable "cluster_name" {
}
variable "cluster_version" {
}
variable "vpc_id" {
}
variable "private_subnets" {
  type    = list(string)
}

variable "public_subnets" {
  type    = list(string)
}


