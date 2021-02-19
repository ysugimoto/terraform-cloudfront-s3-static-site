resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.subdomain}-origin-access-identity"
}

resource "aws_cloudfront_distribution" "cloudfront" {
  enabled             = true
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  comment             = "CloudFront for ${var.subdomain}"

  aliases = [
    "${var.subdomain}.${var.hostzone}"
  ]

  origin {
    domain_name = "${aws_s3_bucket.static.id}.s3-${data.aws_region.current.name}.amazonaws.com"
    origin_id   = var.subdomain

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.subdomain
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    min_ttl     = try(var.cache.min_ttl, 0)
    default_ttl = try(var.cache.default_ttl, 0)
    max_ttl     = try(var.cache.max_ttl, 86400)
    compress    = true

    lambda_function_association {
      event_type = "viewer-request"
      lambda_arn = aws_lambda_function.lambda-edge-router.qualified_arn
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  depends_on = [
    aws_lambda_function.lambda-edge-router,
  ]
}

