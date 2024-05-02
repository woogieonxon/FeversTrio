# output "cluster_id" {
#   value = module.eks.cluster_id
# }
#
# output "cluster_primary_security_group_id" {
#   value = module.eks.cluster_primary_security_group_id
# }

output "private_web_subnet_ids" {
  value = module.my_vpc.private_web_subnet_ids
}

# output "aurora_password" {
#   value = module.aurora.rds-random-password
#   sensitive = true
# }