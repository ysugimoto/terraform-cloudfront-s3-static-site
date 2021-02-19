resource "aws_s3_bucket" "static" {
  bucket = "${var.prefix}${var.subdomain}"
  acl    = "private"
  policy = templatefile(
    "${path.module}/policies/static-site-policy.json",
    {
      cloudfront_identity = aws_cloudfront_origin_access_identity.origin_access_identity.id
      s3_bucket_name      = "${var.prefix}${var.subdomain}"
    }
  )

  depends_on = [
    aws_cloudfront_origin_access_identity.origin_access_identity,
  ]
}

