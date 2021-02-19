data "aws_route53_zone" "hostzone" {
  name         = var.hostzone
  private_zone = false
}

resource "aws_route53_record" "site-record" {
  zone_id = data.aws_route53_zone.hostzone.zone_id
  name    = "${var.subdomain}.${var.hostzone}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [
    aws_cloudfront_distribution.cloudfront,
  ]
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hostzone.zone_id
  records = [
    each.value.record
  ]
  ttl = 60

  depends_on = [
    aws_acm_certificate.cert,
  ]
}
