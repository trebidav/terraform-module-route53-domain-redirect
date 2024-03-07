resource "aws_acm_certificate" "cert" {
  domain_name               = var.zone
  validation_method         = "DNS"
  subject_alternative_names = ["www.${var.zone}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
