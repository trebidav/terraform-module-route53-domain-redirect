data "aws_route53_zone" "zone" {
  name = var.zone
}

resource "aws_route53_record" "redirect-www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = data.aws_route53_zone.zone.name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.redirect.domain_name
    zone_id                = aws_cloudfront_distribution.redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "redirect" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "www.${data.aws_route53_zone.zone.name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.redirect.domain_name
    zone_id                = aws_cloudfront_distribution.redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cert_validation" {
  # https://github.com/hashicorp/terraform-provider-aws/issues/10098#issuecomment-663562342
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options: dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name    = each.value.name
  records = [ each.value.record ]
  type    = each.value.type
  zone_id = data.aws_route53_zone.zone.zone_id

  ttl     = 60
}
