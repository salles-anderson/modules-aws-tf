module "eip_basic" {
  source = "../../../modules/networking/eip"

  project_name = "eip-basic-demo"
  name         = "eip-basic"
}

output "public_ip" {
  value = module.eip_basic.public_ip
}
