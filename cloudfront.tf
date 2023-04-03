resource "aws_cloudfront_distribution" "redirect" {
  origin {
    domain_name = "${aws_s3_bucket.redirect_bucket.bucket}.s3-website.${data.aws_region.current.name}.amazonaws.com"
    origin_id   = aws_s3_bucket.redirect_bucket.bucket

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  price_class     = "PriceClass_100"
  comment         = aws_s3_bucket.redirect_bucket.bucket
  enabled         = true
  is_ipv6_enabled = false

  aliases = ["www.${var.zone}", var.zone]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.redirect_bucket.bucket
    compress         = true

    min_ttl     = 31536000
    max_ttl     = 31536000
    default_ttl = 31536000

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }

  wait_for_deployment = false
  depends_on          = [aws_acm_certificate_validation.validation]
  response_headers_policy_id = aws_cloudfront_response_headers_policy.main.id
}


# https://dev.to/aws-builders/apply-cloudfront-security-headers-policy-with-terraform-fd3
resource "aws_cloudfront_response_headers_policy" "main" {
  name = "${terraform.workspace}-advertiser-security-header-policy"
  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "DENY"
      override = true
    }
    referrer_policy {
      referrer_policy = "same-origin"
      override = true
    }
    xss_protection {
      mode_block = true
      protection = true
      override = true
    }
    strict_transport_security {
      access_control_max_age_sec = "63072000"
      include_subdomains = true
      preload = true
      override = true
    }
    content_security_policy {
      content_security_policy = "frame-ancestors 'none'; default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'"
      override = true
    }
  }
}