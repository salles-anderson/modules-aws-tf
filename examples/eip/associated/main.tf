module "eip_associated" {
  source = "../../../modules/networking/eip"

  project_name = "eip-assoc-demo"
  name         = "eip-assoc"
  instance_id  = "i-0123456789abcdef0" # Dummy Instance ID
}

output "public_ip" {
  value = module.eip_associated.public_ip
}
