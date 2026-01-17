# VPC Module

This module manages a Virtual Private Cloud (VPC) on AWS. It can create a new VPC with public/private topology or "adopt" an existing VPC for reference purposes.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         VPC (10.0.0.0/16)                       │
│                                                                  │
│  ┌────────────────────────┐    ┌────────────────────────┐      │
│  │    Public Subnet A     │    │    Public Subnet B     │      │
│  │     (10.0.1.0/24)      │    │     (10.0.2.0/24)      │      │
│  └───────────┬────────────┘    └────────────────────────┘      │
│              │                                                   │
│              ▼                                                   │
│  ┌───────────────────────┐                                      │
│  │    NAT Gateway        │◄──── Elastic IP                      │
│  └───────────┬───────────┘                                      │
│              │                                                   │
│  ┌───────────▼────────────┐    ┌────────────────────────┐      │
│  │   Private Subnet A     │    │   Private Subnet B     │      │
│  │    (10.0.101.0/24)     │    │    (10.0.102.0/24)     │      │
│  └────────────────────────┘    └────────────────────────┘      │
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │                    VPC Endpoints                        │    │
│  │         S3 (Gateway) | ECR | SSM (Interface)           │    │
│  └────────────────────────────────────────────────────────┘    │
│                          │                                       │
│                          ▼                                       │
│                 Internet Gateway                                 │
└─────────────────────────────────────────────────────────────────┘
                          │
                          ▼
                       Internet
```

If configured to create (`create_vpc = true`), the module provisions:
* `aws_vpc`: The virtual network
* `aws_subnet`: Public and private subnets distributed across specified AZs
* `aws_internet_gateway`: Internet gateway for public subnets
* `aws_nat_gateway`: NAT Gateway (optional) for private subnets to access the internet
* `aws_route_table`: Configured route tables
* `aws_vpc_endpoint`: Endpoints for S3, ECR, and SSM (optional) for private access
* `aws_flow_log`: VPC Flow Logs (optional)

## Features

* Complete network topology creation
* Support for existing VPCs (returns subnet IDs based on tags)
* NAT Gateway configuration (Single NAT GW)
* VPC Endpoints support to increase security and reduce data transfer costs

## Basic Usage (Create New VPC)

```hcl
module "vpc" {
  source = "git::https://github.com/salles-anderson/modules-aws-tf.git//modules/networking/vpc?ref=v1.0.0"

  project_name = "my-vpc"
  vpc_cidr     = "10.0.0.0/16"
  azs          = ["us-east-1a", "us-east-1b"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
}
```

## Usage (Existing VPC)

```hcl
module "vpc_existing" {
  source = "git::https://github.com/salles-anderson/modules-aws-tf.git//modules/networking/vpc?ref=v1.0.0"

  create_vpc      = false
  project_name    = "my-existing-vpc"
  vpc_id_existing = "vpc-12345"

  public_subnet_tags_existing = {
    "Type" = "Public"
  }
  private_subnet_tags_existing = {
    "Type" = "Private"
  }
}
```

## Examples

See `examples/vpc/` for detailed examples:
* [New](../../examples/vpc/new): Creates a complete new VPC
* [Existing](../../examples/vpc/existing): Uses an existing VPC

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_name` | Project name | `string` | n/a | yes |
| `create_vpc` | If `true`, creates resources | `bool` | `true` | no |
| `vpc_id_existing` | Existing VPC ID | `string` | `null` | no |
| `vpc_cidr` | New VPC CIDR | `string` | `10.0.0.0/16` | no |
| `azs` | Availability zones | `list(string)` | `[]` | no |
| `public_subnets` | Public subnet CIDRs | `list(string)` | `[]` | no |
| `private_subnets` | Private subnet CIDRs | `list(string)` | `[]` | no |
| `enable_nat_gateway` | Create NAT Gateway | `bool` | `false` | no |
| `enable_flow_logs` | Enable Flow Logs | `bool` | `false` | no |
| `enable_vpc_endpoints` | Enable VPC Endpoints | `bool` | `true` | no |
| `vpc_endpoint_security_group_ids` | SG IDs for Endpoints | `list(string)` | `[]` | no |
| `tags` | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | VPC ID |
| `vpc_cidr_block` | VPC CIDR |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |
| `nat_gateway_public_ip` | NAT Gateway public IP |
