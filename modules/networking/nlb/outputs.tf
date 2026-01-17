output "lb_arn" {
  description = "ARN do Network Load Balancer."
  value       = aws_lb.this.arn
}

output "lb_dns_name" {
  description = "DNS público do NLB."
  value       = aws_lb.this.dns_name
}

output "lb_zone_id" {
  description = "Hosted zone ID do NLB (para registros Route53 alias)."
  value       = aws_lb.this.zone_id
}

output "target_group_arns" {
  description = "Mapa de ARNs dos target groups."
  value       = { for k, v in aws_lb_target_group.this : k => v.arn }
}

output "listener_arns" {
  description = "Mapa de ARNs dos listeners."
  value       = { for k, v in aws_lb_listener.this : k => v.arn }
}

output "subnet_mapping_eips" {
  description = "Mapa subnet_id -> allocation_id (EIP) associado ao NLB."
  value       = { for m in aws_lb.this.subnet_mapping : m.subnet_id => try(m.allocation_id, null) }
}
