terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.8.0"
    }
  }

  backend "s3" {
    bucket               = "mustang-s3-hyd"
    key                  = "eks.tfstate"
    region               = "us-east-1"
    dynamodb_table       = "terra-dyna"
    encrypt              = true
    workspace_key_prefix = "env"
  }
}
provider "aws" {
  region = "us-east-1"
}