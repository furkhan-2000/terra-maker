variable "eks_cluster" {
  type    = string
  default = "commet"
}

variable "iam_cluster" {
  type    = string
  default = "commet-iam"
}

variable "node_iam_cluster" {
  type    = string
  default = "commet-mini"
}

variable "eks_console" {
  type    = string
  default = "consoleAccess"
}

variable "priendpoint_access" {
  type    = bool
  default = false
}

variable "pubendpoint_access" {
  type    = bool
  default = true
}

variable "pub_cidr" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "capacity_type" {
  type    = string
  default = "SPOT"
}

variable "instance_type" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "desired_size" {
  type    = map(number)
  default = {
    "default" = 2
    "dev"     = 2
    "prd"     = 2
  }
}

variable "min_size" {
  type    = map(number)
  default = {
    "default" = 1
    "dev"     = 1
    "prd"     = 1
  }
}

variable "max_size" {
  type    = map(number)
  default = {
    "default" = 3
    "dev"     = 3
    "prd"     = 3
  }
}

variable "unavailable_node" {
  type    = number
  default = 1
}

variable "worker_agent_name" {
  type    = map(string)
  default = {
    "default" = "default-worker-node"
    "dev"     = "dev-worker-node"
    "prd"     = "prd-worker-node"
  }
}
variable "availability_zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
}