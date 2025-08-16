## WITH STATE FILE MANAGEMENT REMOTELY
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.9.0"
    }
  }

  backend "s3" {
    bucket               = "mustang-s3-hyd"
    key                  = "ecs-terraCrticl"
    region               = "us-east-1"
    encrypt              = true
    dynamodb_table       = "terra-dyna"
    workspace_key_prefix = "env"
  }
}

provider "aws" {
  region = "us-east-1"
}   
#### WITHOUT BACKEND/ WITHOUT REMOTE STATE FILE MANAGEMENT 
/*
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}   */