terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.83.1"
    }
  }

backend "s3" {
    bucket         = "mirinda-soda"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dynabol"
    encrypt = true
    workspace_key_prefix = "env"
  }
  
}

provider "aws" {
  region = "us-east-1"
}