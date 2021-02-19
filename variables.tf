// Specify subdomain name only subject section.
// If you want to create example.yourdomain.com, supply "example".
variable "subdomain" {
  description = "Specify subdomain you want deploy"
  default     = "example"
}

// Specify hostzone domain in your AWS Route53.
variable "hostzone" {
  description = "Specify Route53 hostzone domain which you already have"
  default     = "poc.b12s.jp"
}

// In default, S3 bucket name and IAM role will be "${prefix}${subdomain}"
variable "prefix" {
  description = "You can change S3 bucket name and IAM role prefix what you want"
  default = "terraform-static-"
}

// Override cache TTLs
variable "cache" {
  description = "Override cache TTL behavior"
  default = {
    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 86400
  }
}
