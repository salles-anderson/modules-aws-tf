output "web_acl_arn" {
  description = "ARN do Web ACL."
  value       = aws_wafv2_web_acl.this.arn
}

output "web_acl_id" {
  description = "ID do Web ACL."
  value       = aws_wafv2_web_acl.this.id
}

output "web_acl_name" {
  description = "Nome do Web ACL."
  value       = aws_wafv2_web_acl.this.name
}

output "web_acl_metric_name" {
  description = "Nome da métrica principal do Web ACL."
  value       = local.metric_name
}
