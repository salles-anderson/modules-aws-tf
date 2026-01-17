output "lb_arn" {
  description = "O ARN (Amazon Resource Name) do Load Balancer."
  value       = aws_lb.this.arn
}

output "lb_dns_name" {
  description = "O nome DNS do Load Balancer."
  value       = aws_lb.this.dns_name
}

output "lb_zone_id" {
  description = "O ID da zona hospedada (hosted zone) do Load Balancer, para uso em registros DNS de alias."
  value       = aws_lb.this.zone_id
}

output "target_group_arns" {
  description = "Um mapa dos ARNs dos target groups criados, com as chaves sendo as mesmas da variável `target_groups`."
  value       = { for k, v in aws_lb_target_group.this : k => v.arn }
}

output "target_group_names" {
  description = "Um mapa dos nomes dos target groups criados, com as chaves sendo as mesmas da variável `target_groups`."
  value       = { for k, v in aws_lb_target_group.this : k => v.name }
}

output "listener_arns" {
  description = "Um mapa dos ARNs dos listeners criados, com as chaves sendo as mesmas da variável `listeners`."
  value       = { for k, v in aws_lb_listener.this : k => v.arn }
}