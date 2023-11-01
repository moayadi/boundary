output "sg_id" {
  description = "Security group ID of Vault cluster"
  value       = module.incoming.security_group_id
}

output "private_ip" {
  value = aws_instance.controller.private_ip
}

output "instance_id" {
  value = aws_instance.controller.id
  
}