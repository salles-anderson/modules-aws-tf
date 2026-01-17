# Este arquivo está intencionalmente vazio.
# Este é um repositório de módulos, e não um projeto Terraform para ser executado a partir da raiz.
# Consulte o diretório 'examples' para ver como usar os módulos.

terraform {
  backend "remote" {
    organization = "TeckSolucoes"

    workspaces {
      name = "terraform-aws-modules"
    }
  }
}
