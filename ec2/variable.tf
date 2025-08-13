variable "aws_provider" {
  type    = string
  default = "us-east-1"
}

variable "aws_ami_value" {
  type    = string
  default = "ubuntu/images/hvm-ssd/*amd64*"
}

variable "aws_ami_owner" {
  type    = list(string)
  default = ["amazon"]
}

variable "aws_key_name" {
  type    = string
  default = "N.Virginia"
}

variable "aws_security_group_name" {
  type    = string
  default = "land"
}

variable "instance_type_workspace" {
  type = map(list(string))
  default = {
    "dev"     = ["t2.micro"]
    "prd"     = ["t2.medium", "t2.micro"]
    "default" = ["t2.micro"]
  }
}

variable "volume_size" {
  type = map(number)
  default = {
    "dev"     = 8
    "default" = 8
    "prd"     = 10
  }
}

variable "volume_type" {
  type = map(string)
  default = {
    "dev"     = "gp2"
    "default" = "gp2"
    "prd"     = "gp3"
  }
}
variable "bucket_name" {
  type    = string
  default = "maaza_s3_hyd"
}
variable "bucket_versioning" {
  type    = string
  default = "Enabled"
}
variable "server_side_algorithm" {
  type    = string
  default = "AES256"
}
variable "block_public_acls" {
  type    = bool
  default = true
}
variable "ignore_public_acls" {
  type    = bool
  default = true
}
variable "public_policy" {
  type    = bool
  default = true
}
variable "public_buckets" {
  type    = bool
  default = true
}
