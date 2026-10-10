output "security_group_id" {
  description = "ID of the instances' security group."
  value       = aws_security_group.this.id
}

output "instance_ids" {
  description = "IDs of the instances."
  value       = aws_instance.this[*].id
}

output "public_ips" {
  description = "Public IPs of the instances (Elastic IPs when assigned)."
  value       = var.assign_eip ? aws_eip.this[*].public_ip : aws_instance.this[*].public_ip
}

output "private_ips" {
  description = "Private IPs of the instances."
  value       = aws_instance.this[*].private_ip
}
