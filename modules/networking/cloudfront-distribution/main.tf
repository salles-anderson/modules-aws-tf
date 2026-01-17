locals {
  tags = merge(
    {
      Project = var.project_name
    },
    var.tags,
  )
}

resource "aws_cloudfront_origin_access_identity" "this" {
  count   = var.create_origin_access_identity && var.origin_is_s3 ? 1 : 0
  comment = var.oai_comment
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  comment             = var.distribution_comment
  price_class         = var.price_class
  aliases             = var.aliases
  default_root_object = var.default_root_object
  web_acl_id          = var.web_acl_id
  is_ipv6_enabled     = var.is_ipv6_enabled

  origin {
    domain_name = var.origin_domain_name
    origin_id   = var.origin_id
    origin_path = var.origin_path

    dynamic "s3_origin_config" {
      for_each = var.origin_is_s3 ? [1] : []
      content {
        origin_access_identity = var.create_origin_access_identity ? aws_cloudfront_origin_access_identity.this[0].cloudfront_access_identity_path : var.origin_access_identity
      }
    }

    dynamic "custom_origin_config" {
      for_each = var.origin_is_s3 ? [] : [1]
      content {
        http_port              = var.custom_origin_http_port
        https_port             = var.custom_origin_https_port
        origin_protocol_policy = var.origin_protocol_policy
        origin_ssl_protocols   = var.origin_ssl_protocols
      }
    }
  }

  default_cache_behavior {
    target_origin_id         = var.origin_id
    allowed_methods          = var.allowed_methods
    cached_methods           = var.cached_methods
    viewer_protocol_policy   = var.viewer_protocol_policy
    compress                 = true
    cache_policy_id          = var.cache_policy_id
    origin_request_policy_id = var.origin_request_policy_id

    dynamic "lambda_function_association" {
      for_each = var.lambda_function_associations
      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = lookup(lambda_function_association.value, "include_body", null)
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_bucket != null ? [1] : []
    content {
      bucket          = var.logging_bucket
      include_cookies = var.logging_include_cookies
      prefix          = var.logging_prefix
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = "TLSv1.2_2019"
    cloudfront_default_certificate = var.acm_certificate_arn == null
  }

  tags = merge(
    local.tags,
    {
      Name = var.distribution_comment
    },
  )
}
