provider "aws" {
  region  = local.env.region
  profile = local.env.profile
}

terraform {
  required_version = ">= 1.8.5"

  backend "s3" {
    bucket = "vchauhan-back-test"
    key    = "terraform-infra"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.55.0"
    }
  }
}





