resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.subdomain}.${var.hostzone}"
  validation_method = "DNS"
  provider          = aws.virginia

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
  provider                = aws.virginia
}
