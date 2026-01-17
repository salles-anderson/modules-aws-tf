locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )

  # effective_clients (clientes efetivos):
  # - se var.clients vier preenchido, usa multi-client
  # - se var.clients estiver vazio, cria 1 client "legacy" usando as variáveis antigas
  effective_clients = length(var.clients) > 0 ? var.clients : {
    legacy = {
      name                         = coalesce(var.user_pool_client_name, "${var.user_pool_name}-legacy-client")
      generate_secret              = var.client_generate_secret
      callback_urls                = var.client_callback_urls
      logout_urls                  = var.client_logout_urls
      allowed_oauth_flows          = var.client_allowed_oauth_flows
      allowed_oauth_scopes         = var.client_allowed_oauth_scopes
      supported_identity_providers = var.client_supported_identity_providers
      explicit_auth_flows          = var.client_explicit_auth_flows
    }

  }
}

resource "aws_cognito_user_pool" "this" {
  name                       = var.user_pool_name
  auto_verified_attributes   = var.auto_verified_attributes
  mfa_configuration          = var.mfa_configuration
  email_verification_subject = var.email_verification_subject
  email_verification_message = var.email_verification_message

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  dynamic "software_token_mfa_configuration" {
    for_each = var.enable_software_token_mfa ? [1] : []
    content {
      enabled = true
    }
  }

  password_policy {
    minimum_length                   = var.password_min_length
    require_lowercase                = var.password_require_lowercase
    require_numbers                  = var.password_require_numbers
    require_symbols                  = var.password_require_symbols
    require_uppercase                = var.password_require_uppercase
    temporary_password_validity_days = var.temporary_password_validity_days
  }

  tags = merge(
    local.tags,
    { Name = var.user_pool_name }
  )
}

# Multi-client (múltiplos app clients) com fallback legacy
resource "aws_cognito_user_pool_client" "clients" {
  for_each = local.effective_clients

  name         = each.value.name
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret = try(each.value.generate_secret, false)

  callback_urls        = try(each.value.callback_urls, [])
  logout_urls          = try(each.value.logout_urls, [])
  allowed_oauth_flows  = try(each.value.allowed_oauth_flows, [])
  allowed_oauth_scopes = try(each.value.allowed_oauth_scopes, [])

  allowed_oauth_flows_user_pool_client = length(try(each.value.allowed_oauth_flows, [])) > 0

  supported_identity_providers = try(each.value.supported_identity_providers, ["COGNITO"])
  explicit_auth_flows          = try(each.value.explicit_auth_flows, ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"])

  prevent_user_existence_errors = "ENABLED"

  lifecycle {
    ignore_changes = [
      access_token_validity,
      id_token_validity,
      refresh_token_validity,
      token_validity_units,
      auth_session_validity
    ]
  }
}


# Custom Domain (domínio custom) opcional: auth.dev... + Route53 alias
resource "aws_cognito_user_pool_domain" "custom" {
  count = var.custom_domain.enabled ? 1 : 0

  domain          = var.custom_domain.domain_name
  user_pool_id    = aws_cognito_user_pool.this.id
  certificate_arn = var.custom_domain.certificate_arn
}

resource "aws_route53_record" "custom_domain_alias" {
  count = var.custom_domain.enabled ? 1 : 0

  zone_id = var.custom_domain.route53_zone_id
  name    = var.custom_domain.domain_name
  type    = "A"

  alias {
    name                   = aws_cognito_user_pool_domain.custom[0].cloudfront_distribution
    zone_id                = aws_cognito_user_pool_domain.custom[0].cloudfront_distribution_zone_id
    evaluate_target_health = false
  }
}
