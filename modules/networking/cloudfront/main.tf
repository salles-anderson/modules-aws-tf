locals {
  tags = merge(
    {
      "Project" = var.project_name
    },
    var.tags,
  )
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  aliases             = var.aliases
  comment             = coalesce(var.comment, var.name)
  default_root_object = var.default_root_object
  http_version        = var.http_version
  is_ipv6_enabled     = var.is_ipv6_enabled
  price_class         = var.price_class
  wait_for_deployment = var.wait_for_deployment
  web_acl_id          = var.web_acl_id

  dynamic "origin" {
    for_each = var.origins

    content {
      domain_name = origin.value.domain_name
      origin_id   = coalesce(try(origin.value.origin_id, null), "origin-${origin.key}")
      origin_path = try(origin.value.origin_path, null)

      connection_attempts = try(origin.value.connection_attempts, 3)
      connection_timeout  = try(origin.value.connection_timeout, 10)

      dynamic "custom_header" {
        for_each = try(origin.value.custom_headers, {})

        content {
          name  = custom_header.key
          value = custom_header.value
        }
      }

      dynamic "s3_origin_config" {
        for_each = try(origin.value.s3_origin_config, null) == null ? [] : [origin.value.s3_origin_config]

        content {
          origin_access_identity = try(s3_origin_config.value.origin_access_identity, null)
        }
      }

      dynamic "custom_origin_config" {
        for_each = try(origin.value.custom_origin_config, null) == null ? [] : [origin.value.custom_origin_config]

        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
          origin_keepalive_timeout = try(custom_origin_config.value.origin_keepalive_timeout, 5)
          origin_read_timeout      = try(custom_origin_config.value.origin_read_timeout, 30)
        }
      }

      dynamic "origin_shield" {
        for_each = try(origin.value.origin_shield, null) == null ? [] : [origin.value.origin_shield]

        content {
          enabled              = try(origin_shield.value.enabled, true)
          origin_shield_region = origin_shield.value.origin_shield_region
        }
      }
    }
  }

  default_cache_behavior {
    target_origin_id       = var.default_cache_behavior.target_origin_id
    viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy
    allowed_methods        = var.default_cache_behavior.allowed_methods
    cached_methods         = var.default_cache_behavior.cached_methods
    compress               = try(var.default_cache_behavior.compress, true)

    forwarded_values {
      query_string = try(var.default_cache_behavior.query_string, false)
      headers      = try(var.default_cache_behavior.forwarded_headers, [])

      cookies {
        forward           = try(var.default_cache_behavior.cookies_forward, "none")
        whitelisted_names = try(var.default_cache_behavior.cookies_whitelist, [])
      }
    }

    min_ttl     = try(var.default_cache_behavior.min_ttl, 0)
    default_ttl = try(var.default_cache_behavior.default_ttl, 86400)
    max_ttl     = try(var.default_cache_behavior.max_ttl, 31536000)

    dynamic "lambda_function_association" {
      for_each = try(var.default_cache_behavior.lambda_function_associations, [])

      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = try(lambda_function_association.value.include_body, false)
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors

    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      target_origin_id       = ordered_cache_behavior.value.target_origin_id
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      compress               = try(ordered_cache_behavior.value.compress, true)

      forwarded_values {
        query_string = try(ordered_cache_behavior.value.query_string, false)
        headers      = try(ordered_cache_behavior.value.forwarded_headers, [])

        cookies {
          forward           = try(ordered_cache_behavior.value.cookies_forward, "none")
          whitelisted_names = try(ordered_cache_behavior.value.cookies_whitelist, [])
        }
      }

      min_ttl     = try(ordered_cache_behavior.value.min_ttl, 0)
      default_ttl = try(ordered_cache_behavior.value.default_ttl, 86400)
      max_ttl     = try(ordered_cache_behavior.value.max_ttl, 31536000)

      dynamic "lambda_function_association" {
        for_each = try(ordered_cache_behavior.value.lambda_function_associations, [])

        content {
          event_type   = lambda_function_association.value.event_type
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = try(lambda_function_association.value.include_body, false)
        }
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.restrictions.geo_restriction.restriction_type
      locations        = try(var.restrictions.geo_restriction.locations, [])
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_config == null ? [] : [var.logging_config]

    content {
      bucket          = logging_config.value.bucket
      prefix          = try(logging_config.value.prefix, null)
      include_cookies = try(logging_config.value.include_cookies, false)
    }
  }

  viewer_certificate {
    acm_certificate_arn            = try(var.viewer_certificate.acm_certificate_arn, null)
    cloudfront_default_certificate = try(var.viewer_certificate.cloudfront_default_certificate, null)
    iam_certificate_id             = try(var.viewer_certificate.iam_certificate_id, null)
    minimum_protocol_version       = try(var.viewer_certificate.minimum_protocol_version, null)
    ssl_support_method             = try(var.viewer_certificate.ssl_support_method, null)
  }

  tags = merge(
    local.tags,
    {
      "Name" = var.name
    }
  )
}
