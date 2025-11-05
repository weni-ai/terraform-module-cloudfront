resource "aws_cloudfront_origin_access_control" "this" {
  for_each = {
    for origin in var.origins : origin.id => origin
    if lookup(origin, "origin_access_control", false)
  }

  name                              = each.key
  description                       = "OAC para origin ${each.key}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Definição principal da distribuição
resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  comment             = var.comment
  price_class         = var.price_class
  is_ipv6_enabled     = true
  http_version        = "http2"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Configurações SSL / HTTPS
  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn == null ? null : "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  # Origins - múltiplos buckets S3
  dynamic "origin" {
    for_each = var.origins
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.id
      origin_path = lookup(origin.value, "path", null)

      origin_access_control_id = lookup(origin.value, "origin_access_control", false) ? (
        aws_cloudfront_origin_access_control.this[origin.value.id].id
      ) : null

      # Lógica para suportar OAI (legado)
      dynamic "s3_origin_config" {
        for_each = lookup(origin.value, "origin_access_control", false) ? [] : (
          lookup(origin.value, "origin_access_identity", null) != null ? [1] : []
        )
        content {
          origin_access_identity = origin.value.origin_access_identity
        }
      }
    }
  }

  default_cache_behavior {
    target_origin_id       = var.default_cache_behavior.target_origin_id
    viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy
    allowed_methods        = var.default_cache_behavior.allowed_methods
    cached_methods         = var.default_cache_behavior.cached_methods
    compress               = var.default_cache_behavior.compress
    default_ttl            = lookup(var.default_cache_behavior, "default_ttl", 3600)
    max_ttl                = lookup(var.default_cache_behavior, "max_ttl", 86400)
    min_ttl                = lookup(var.default_cache_behavior, "min_ttl", 0)

    forwarded_values {
      query_string = lookup(var.default_cache_behavior, "query_string", false)
      cookies {
        forward = lookup(var.default_cache_behavior, "cookies_forward", "none")
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
      compress               = ordered_cache_behavior.value.compress

      forwarded_values {
        query_string = lookup(ordered_cache_behavior.value, "query_string", false)
        cookies {
          forward = lookup(ordered_cache_behavior.value, "cookies_forward", "none")
        }
      }
    }
  }

  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = var.error_page_path
    error_caching_min_ttl = 300
  }
  
  custom_error_response {
    error_code         = 403
    response_code      = 403
    response_page_path = var.error_page_path
    error_caching_min_ttl = 300
  }

  # Logging (opcional)
  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []
    content {
      include_cookies = lookup(logging_config.value, "include_cookies", false)
      bucket          = logging_config.value.bucket
      prefix          = lookup(logging_config.value, "prefix", null)
    }
  }

  tags = var.tags
  aliases = var.aliases
}