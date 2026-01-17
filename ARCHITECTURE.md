# Terraform Modules Repository Architecture

This repository contains a collection of reusable Terraform modules for AWS, organized by categories to facilitate maintenance and usage.

## Directory Structure

The repository structure is as follows:

```
.
├── modules/                 # Contains all Terraform modules
│   ├── compute/             # Compute-related modules (EC2, ECS, EKS, etc.)
│   ├── cost-optimization/   # Cost optimization modules (schedulers)
│   ├── database/            # Database modules (RDS, DynamoDB, etc.)
│   ├── iam/                 # IAM-specific modules (Roles, Policies)
│   ├── networking/          # Networking modules (VPC, ALB, Route53, etc.)
│   ├── observability/       # Observability modules (CloudWatch, etc.)
│   ├── security/            # Security modules (SG, ACM, WAF, etc.)
│   ├── serverless/          # Serverless modules (Lambda, SQS, etc.)
│   └── storage/             # Storage modules (S3, EFS, ECR, etc.)
├── examples/                # Usage examples for each module
├── ARCHITECTURE.md          # This document
├── CONTRIBUTING.md          # Contributing guide
└── README.md                # Main documentation
```

## Design Principles

The modules in this repository follow these design principles:

### 1. Single Responsibility Principle (SRP)
Each module should have a single responsibility. For example, a VPC module should not create EKS clusters, and an ACM module should only manage certificates. This ensures modules are focused, easy to understand, and reusable.

### 2. Composition over Inheritance
We prefer composing smaller modules to build complex infrastructures, rather than creating monolithic "wrapper" modules that try to do everything. Use a root module to call specialized modules (networking, compute, database) as needed.

### 3. DRY (Don't Repeat Yourself)
Avoid code duplication. If logic is used in multiple places, consider extracting it to a submodule or using native Terraform features like `for_each` and `count`.

### 4. Security by Default
* **Avoid hardcoded credentials:** Never insert access keys or passwords in code. Use variables or data sources.
* **Least Privilege:** IAM policies should grant only the permissions necessary for the function.
* **Encryption:** Enable encryption at rest and in transit whenever possible (S3, RDS, EBS, etc.).

### 5. Input Validation
Use `validation` blocks in input variables to ensure data integrity before plan execution. This provides quick feedback to users and prevents late errors.

## Conventions

### Module Structure
Every module must contain, at minimum, the following files:
* `main.tf`: Main module logic.
* `variables.tf`: Definition of input variables with descriptions and validations.
* `outputs.tf`: Definition of module outputs.
* `README.md`: Detailed module documentation, including usage examples.

### Versioning
This repository follows semantic versioning. Changes should be atomic and documented.

### Formatting
All code must be formatted using `terraform fmt`.

## Using the Modules

To use a module, reference it in your Terraform code pointing to the directory path or repository URL (with the appropriate version tag).

Generic example:

```hcl
module "example" {
  source = "git::https://github.com/salles-anderson/modules-aws-tf.git//modules/category/module-name?ref=v1.0.0"

  parameter1 = "value1"
  parameter2 = "value2"
}
```

Refer to the `examples/` directory for practical examples of how to instantiate each module.
