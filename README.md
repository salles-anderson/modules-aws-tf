# Terraform AWS Modules

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonwebservices&logoColor=white)

A collection of reusable, production-ready Terraform modules for AWS infrastructure provisioning. Designed to be modular, secure, and easy to use.

## Documentation

- **[Architecture & Design](ARCHITECTURE.md)**: Design principles and repository structure
- **[Contributing Guide](CONTRIBUTING.md)**: How to contribute to this project

## Available Modules

Modules are organized by category. Click on the module name to view its detailed documentation.

### Compute

| Module | Description |
|--------|-------------|
| [ec2-instance](modules/compute/ec2-instance) | Simple or complex EC2 instances |
| [ec2-rke2-node](modules/compute/ec2-rke2-node) | EC2 nodes optimized for RKE2 Kubernetes |
| [ecr-repository](modules/compute/ecr-repository) | ECR repositories for Docker images |
| [ecs-cluster](modules/compute/ecs-cluster) | ECS clusters with Fargate or EC2 |
| [ecs-service](modules/compute/ecs-service) | Services and tasks on Amazon ECS |
| [ecs-service-autoscaling](modules/compute/ecs-service-autoscaling) | Auto scaling for ECS services with scheduled scaling support |
| [kong-gateway](modules/compute/kong-gateway) | Kong API Gateway on ECS Fargate |

### Cost Optimization

| Module | Description |
|--------|-------------|
| [documentdb-scheduler](modules/cost-optimization/documentdb-scheduler) | Stop/start scheduling for DocumentDB clusters |
| [ec2-scheduler](modules/cost-optimization/ec2-scheduler) | Stop/start scheduling for EC2 instances |
| [rds-scheduler](modules/cost-optimization/rds-scheduler) | Stop/start scheduling for RDS instances/clusters |

### Database

| Module | Description |
|--------|-------------|
| [documentdb-cluster](modules/database/documentdb-cluster) | Amazon DocumentDB clusters (MongoDB compatible) |
| [dynamodb-backup-plan](modules/database/dynamodb-backup-plan) | AWS Backup plans for DynamoDB |
| [dynamodb-table](modules/database/dynamodb-table) | DynamoDB tables with flexible configuration |
| [elasticache-redis](modules/database/elasticache-redis) | ElastiCache Redis clusters |
| [rds-aurora-cluster](modules/database/rds-aurora-cluster) | Aurora MySQL/PostgreSQL clusters |
| [rds-mysql](modules/database/rds-mysql) | RDS MySQL instances |
| [rds-postgres](modules/database/rds-postgres) | RDS PostgreSQL instances |

### Networking

| Module | Description |
|--------|-------------|
| [alb](modules/networking/alb) | Application Load Balancer |
| [cloudfront](modules/networking/cloudfront) | Simplified CloudFront distribution |
| [cloudfront-distribution](modules/networking/cloudfront-distribution) | CloudFront distribution with advanced configuration |
| [eip](modules/networking/eip) | Elastic IP addresses |
| [nlb](modules/networking/nlb) | Network Load Balancer |
| [route53](modules/networking/route53) | Route53 DNS zones and records |
| [vpc](modules/networking/vpc) | VPC, subnets, gateways, and NAT |
| [vpc-peering](modules/networking/vpc-peering) | VPC peering connections |
| [vpc_v2](modules/networking/vpc_v2) | VPC v2 with advanced configuration |

### Observability

| Module | Description |
|--------|-------------|
| [cloudwatch-alarms](modules/observability/cloudwatch-alarms) | CloudWatch alarms with presets for ECS, RDS, Lambda, and ALB |
| [cloudwatch-dashboards](modules/observability/cloudwatch-dashboards) | CloudWatch dashboards with pre-built templates |
| [cloudwatch-log-groups](modules/observability/cloudwatch-log-groups) | Log Groups with KMS, metric filters, and subscriptions support |

### Security

| Module | Description |
|--------|-------------|
| [acm](modules/security/acm) | SSL/TLS certificates via AWS Certificate Manager |
| [cloudtrail](modules/security/cloudtrail) | API call auditing with CloudTrail |
| [cognito-user-pool](modules/security/cognito-user-pool) | Amazon Cognito user pools |
| [iam-role](modules/security/iam-role) | Generic IAM role creation |
| [kms-key](modules/security/kms-key) | KMS encryption keys |
| [secrets-manager-secret](modules/security/secrets-manager-secret) | AWS Secrets Manager secrets |
| [security-group](modules/security/security-group) | Security groups |
| [shield-protection](modules/security/shield-protection) | DDoS protection with AWS Shield |
| [ssm-bastion](modules/security/ssm-bastion) | SSM-managed bastion host (no exposed SSH) |
| [waf](modules/security/waf) | Web Application Firewall |

### Serverless

| Module | Description |
|--------|-------------|
| [amplify-app](modules/serverless/amplify-app) | AWS Amplify applications |
| [eventbridge-scheduler](modules/serverless/eventbridge-scheduler) | EventBridge Scheduler schedules |
| [lambda](modules/serverless/lambda) | Lambda functions with complete configuration |
| [sqs-queue](modules/serverless/sqs-queue) | SQS Standard and FIFO queues |

### Storage

| Module | Description |
|--------|-------------|
| [ecr](modules/storage/ecr) | ECR repositories for Docker images |
| [s3-bucket](modules/storage/s3-bucket) | S3 buckets with security best practices |

## Cost Savings with Cost Optimization

The **Cost Optimization** modules can save up to **70%** on development and staging environments through automatic stop/start scheduling.

| Resource | Estimated Savings |
|----------|-------------------|
| EC2 | ~70% (no time limit when stopped) |
| RDS | ~70% (auto-starts after 7 days - module handles this) |
| DocumentDB | ~70% (auto-starts after 7 days - module handles this) |
| ECS/Fargate | ~70% (via scheduled scaling to 0) |

## Examples

Usage examples for each module are available in the `examples/` directory.

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.0 |
| AWS Provider | >= 5.0 |

## License

[MIT](LICENSE)

## Author

**Anderson Sales** - DevOps Cloud Engineer

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/salesanderson)
