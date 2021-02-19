# terraform-cloudfront-s3-static-site

Create static site using AWS CloudFront and S3 stack by Terraform.

## Requirements

- Terraform `v0.14.2` or later
- AWS Access Keys

## Describe

This module provides all sets of static site components in AWS:

- CloudFront, CDN of serving S3 files
- S3, host static files
- Route53, make subdomain to host your site
- Lambda@@Edge, router for CloudFront
- IAM, make Lambda@Edge execution role
- Certificate Manager, make certificate for CloudFront

**Note that Route53's hosted zone isn't under management in this module. Make sure you have one hosted zone in Route53.**

## Usage

Clone this repository and configure `variables.tf`. Here are configurations of variables:

| variable          | required | default           | description                                                                                               |
|:------------------|:---------|:------------------|:----------------------------------------------------------------------------------------------------------|
| subdomain         | yes      | None              | subdomain which you want to deploy                                                                        |
| hostzone          | yes      | None              | specify AWS Route53 hostzone domain you already have                                                      |
| prefix            | no       | terraform-static- | S3 bucket and IAM role name, and Lambda@Edge prefix. Typically declare to not to conflict other resources |
| cache.min_ttl     | no       | 0                 | CloudFront minimum cache TTL setting                                                                      |
| cache.default_ttl | no       | 0                 | CloudFront default cache TTL setting                                                                      |
| cache.max_ttl     | no       | 86400             | CloudFront maximum cache TTL setting                                                                      |

After you did configuration, let's apply:

```shell
$ terraform init
$ terraform apply
```

After finished to apply, you're ready to open host static site! A S3 bucket is created named from configuration like `${prefix}${subdomain}` (e.g. terraform-static-example). Let's put some built static files to S3 bucket and access the url of https://${subdomain}.${hostzone} :+1: 

## Important

`Lambda@Edge` will be replicated all regions on CloudFront, therefore `terraform destroy` may show error like:

```
Error: error deleting Lambda Function (${prefix}lambda-edge-router): InvalidParameterValueException: Lambda was unable to delete arn:aws:lambda:us-east-1:xxxxxx:function:${prefix}lambda-edge-router:1 because it is a replicated function. Please see our documentation for Deleting Lambda@Edge Functions and Replicas.
{
  RespMetadata: {
  StatusCode: 400,
  RequestID: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  },
  Message_: "Lambda was unable to delete arn:aws:lambda:us-east-1:xxxxxxx:function:terraform-static-lambda-edge-router:1 because it is a replicated function. Please see our documentation for Deleting Lambda@Edge Functions and Replicas."
}
```

It suspect AWS issue, but we don't have solve it.
Workaround refers to here https://github.com/hashicorp/terraform-provider-aws/issues/1721

To do mannualy, follow below:

### 1. Delete Lambda@Edge state

```
$ terraform state rm module.static-site-stack.aws_lambda_function.lambda-edge-router
```

### 2. Destroy Stack

```
$ terraform destroy
```

### 3. Delete Lambda@Edge function

Adter around 1 hour to stop replications, you need to delete that function manually (from console or CLI)


## License

MIT

## Author

Yoshiaki Susigmoto
