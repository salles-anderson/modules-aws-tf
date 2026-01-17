# Contributing Guide

Thank you for considering contributing to this Terraform modules repository! Follow these guidelines to ensure your contributions are integrated smoothly and effectively.

## Workflow

1. **Fork and Clone**: Fork this repository and clone it to your local machine.
2. **Create a Branch**: Create a branch for your feature or fix (`git checkout -b feature/my-new-feature`).
3. **Develop**: Make your changes, following the code and design standards described in `ARCHITECTURE.md`.
4. **Test**: Validate your changes locally.
5. **Commit**: Make atomic commits with descriptive messages.
6. **Push**: Push your branch to your fork.
7. **Pull Request**: Open a Pull Request to the main branch of this repository.

## Code Standards

* **Formatting**: Run `terraform fmt -recursive .` at the repository root before committing. All code must be properly formatted.
* **Validation**: Run `terraform validate` inside the module directory you changed to ensure the syntax is correct.
* **Documentation**:
  * Update the module's `README.md` if you add or remove variables or outputs.
  * If creating a new module, use `terraform-docs` or follow the standard template from other modules (Description, Architecture Diagram, Requirements, Providers, Modules, Resources, Inputs, Outputs).
* **Examples**: Always add or update examples in the `examples/` directory to demonstrate how to use new features or modules.

## Commit Messages

We use the [Conventional Commits](https://www.conventionalcommits.org/) standard. Messages should follow the format:

```
<type>(<optional scope>): <description>

[optional body]

[optional footer]
```

Common types:
* `feat`: A new feature (adds a new module or resource).
* `fix`: A bug fix.
* `docs`: Documentation-only changes.
* `style`: Changes that don't affect the meaning of code (whitespace, formatting, etc).
* `refactor`: A code change that neither fixes a bug nor adds a feature.
* `test`: Adding missing tests or correcting existing tests.
* `chore`: Changes to build process, auxiliary tools, etc.

Example:
```
feat(rds): add support for storage_encrypted encryption
```

## Testing

Before submitting your PR:
1. Navigate to the relevant example directory in `examples/`.
2. Run `terraform init`.
3. Run `terraform validate`.
4. If possible, run `terraform plan` to verify the generated plan is as expected (be careful with AWS costs if applying).

## New Module Structure

New modules should be placed in the appropriate category within `modules/` (compute, database, networking, etc.). If a new category is needed, discuss it in the Pull Request.

Each module must have:
* `main.tf`
* `variables.tf`
* `outputs.tf`
* `README.md`

We appreciate your contributions!
