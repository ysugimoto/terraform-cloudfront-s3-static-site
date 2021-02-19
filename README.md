# terraform-cloudfront-s3-static-site

Create static site using AWS CloudFront and S3 stack by Terraform.

## Requirements

- Terraform `v0.14.2` or later
- AWS Access Keys

## Describe

This module provided all sets of static site components in AWS:

- CloudFront, CDN of serving S3 files
- S3, host static files
- Route53, make subdomain to host your site
- Certificate Manager, make certificate for subdomain on CloudFront

*Note that Route53's hosted zone isn't under management in this module. Make sure you have one hosted zone in Route53.*

## Usage

Clone this repository and configure `variables.tf`. Here are configurations of variables:

| variable          | default           | description                                                                                                       |
|:------------------|:------------------|:------------------------------------------------------------------------------------------------------------------|
| subdomain         | None              | subdomain which you want to deploy                                                                                |
| hostzone          | None              | specify AWS Route53 hostzone domain you already have                                                              |
| bucket-prefix     | terraform-static- | S3 bucket name prefix. Typically add prefix to not to conflict bucket name. value must have `-` suffix if you set |
| cache.min_ttl     | 0                 | CloudFront minimum cache TTL setting                                                                              |
| cache.default_ttl | 0                 | CloudFront default cache TTL setting                                                                              |
| cache.max_ttl     | 0                 | CloudFront maximum cache TTL setting                                                                              |

After you did configuration, please apply:

```shell
terraform init
terraform apply
```

## License

MIT

## Author

Yoshiaki Susigmoto
