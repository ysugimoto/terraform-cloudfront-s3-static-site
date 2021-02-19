provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

data "aws_region" "current" {}
