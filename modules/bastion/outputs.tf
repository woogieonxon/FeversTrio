output "bastion_host_id" {
  description = "The ID of the bastion host"
  value       = aws_instance.bastion.id
}

output "bastion_host_sg_id" {
  description = "The ID of the security group attached to the bastion host"
  value       = aws_security_group.bastion_sg.id
}
