variable "cluster_name" {
  type    = string
  default = "green-veggi"
}

variable "instance_type" {
  type = map(string)
  default = {
    "default" = "t2.medium"
    "dev"     = "t3.large"
    "prd"     = "t3.medium"
  }
}

variable "desired_capacity" {
  type = map(number)
  default = {
    "default" = 2
    "dev"     = 2
    "prd"     = 3
  }
}

variable "max_size" {
  type = map(number)
  default = {
    "default" = 3
    "dev"     = 3
    "prd"     = 4
  }
}

variable "min_size" {
  type = map(number)
  default = {
    "default" = 1
    "dev"     = 1
    "prd"     = 2
  }
}

variable "key_name" {
  type = string 
  default = "N.Virginia"
}

variable "availability_filter" {
  type = list(string) 
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
}
variable "architecture" {
  type = list(string)
  default = ["x86_64"]
}