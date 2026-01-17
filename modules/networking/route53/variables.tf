variable "zone_id" {
  description = "O ID da Hosted Zone do Route53 onde os registros serão criados."
  type        = string

  validation {
    condition     = substr(var.zone_id, 0, 1) == "Z"
    error_message = "O ID da Hosted Zone deve começar com 'Z'."
  }
}

variable "records" {
  description = <<-EOF
  Um mapa de objetos, onde cada objeto representa um registro DNS a ser criado.
  A chave do mapa é usada para identificação interna e não tem impacto no recurso criado.

  Cada objeto deve conter:
  - `name`: (Obrigatório) O nome do registro (ex: "www", "api", "subdominio").
  - `type`: (Obrigatório) O tipo do registro (ex: "A", "CNAME", "AAAA", "TXT").
  - `ttl`: (Opcional) O Time To Live (TTL) do registro em segundos. Padrão é 300.
  - `values`: (Opcional) Uma lista de valores para o registro (ex: endereços IP para registros 'A').
  - `alias`: (Opcional) Um mapa para criar registros ALIAS. Se presente, `values` e `ttl` são ignorados.
    - `name`: (Obrigatório) O nome DNS do recurso de destino (ex: o DNS de um ALB, CloudFront).
    - `zone_id`: (Obrigatório) O ID da Hosted Zone do recurso de destino.
    - `evaluate_target_health`: (Obrigatório) Booleano que indica se a saúde do alvo deve ser avaliada.
  EOF
  type        = any
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.records :
      lookup(v, "name", null) != null && lookup(v, "type", null) != null && (
        (lookup(v, "values", null) != null && lookup(v, "alias", null) == null) ||
        (
          lookup(v, "alias", null) != null &&
          try(v.alias.name, null) != null &&
          try(v.alias.zone_id, null) != null &&
          try(v.alias.evaluate_target_health, null) != null &&
          lookup(v, "values", null) == null
        )
      )
    ])
    error_message = "Cada registro deve ter 'name' e 'type'. Deve conter 'values' OU um bloco 'alias' com 'name', 'zone_id', e 'evaluate_target_health'."
  }
}
