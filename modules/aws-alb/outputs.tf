output "lb_arn" {
  description = "ARN of Vault load balancer"
  value       = aws_lb.lb.arn
}

output "lb_dns_name" {
  description = "DNS name of Vault load balancer"
  value       = aws_lb.lb.dns_name
}

output "lb_sg_id" {
  description = "Security group ID of Vault load balancer"
  value       = var.lb_type == "application" ? aws_security_group.lb[0].id : null
}

output "lb_zone_id" {
  description = "Zone ID of Vault load balancer"
  value       = aws_lb.lb.zone_id
}

output "target_group_arn" {
  description = "Target group ARN to register Vault nodes with"
  value       = aws_lb_target_group.tg.arn
}
