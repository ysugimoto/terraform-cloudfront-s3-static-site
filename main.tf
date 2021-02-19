provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_version = ">= 0.14.2, < 0.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.21.0"
    }
  }
}

module "static-site-stack" {
  source = "./aws"

  subdomain = var.subdomain
  hostzone  = var.hostzone
  cache     = var.cache
  prefix    = var.prefix
}
