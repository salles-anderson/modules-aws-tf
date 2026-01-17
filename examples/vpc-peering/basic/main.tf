module "peering" {
  source = "../../../modules/networking/vpc-peering"

  requester_vpc_id         = "vpc-0123456789abcdef0" # Dummy VPC A
  requester_vpc_cidr       = "10.0.0.0/16"
  requester_route_table_id = "rtb-0123456789abcdef0" # Dummy RT A
  requester_name           = "VPC-A"

  accepter_vpc_id         = "vpc-0123456789abcdef1" # Dummy VPC B
  accepter_vpc_cidr       = "10.1.0.0/16"
  accepter_route_table_id = "rtb-0123456789abcdef1" # Dummy RT B
  accepter_name           = "VPC-B"
}

output "peering_id" {
  value = module.peering.peering_connection_id
}
