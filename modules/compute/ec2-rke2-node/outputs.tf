output "instance_ids" {
  description = "Lista de IDs das instâncias EC2 criadas."
  value       = aws_instance.rke2_node[*].id
}

output "private_ips" {
  description = "Lista de IPs privados das instâncias EC2 criadas."
  value       = aws_instance.rke2_node[*].private_ip
}

output "ami_used" {
  description = "A ID da AMI que foi usada para provisionar as instâncias."
  value       = data.aws_ami.ubuntu.id
}