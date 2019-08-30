data "aws_route53_zone" "zone" {
  name = "${var.zone}"
}

resource "aws_route53_record" "redirect-www" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${data.aws_route53_zone.zone.name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.redirect.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.redirect.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "redirect" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "www.${data.aws_route53_zone.zone.name}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.redirect.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.redirect.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cert_validation_1" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "cert_validation_2" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}
