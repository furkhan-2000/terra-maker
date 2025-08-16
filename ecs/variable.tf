variable "ecs_cluster" {
  type    = string
  default = "apple-cluster"
}
variable "insights" {
  type    = string
  default = "enabled"
}
variable "ecs_name" {
  type    = string
  default = "apple-serv"
}
variable "family" {
  type    = string
  default = "apple-family"
}
variable "network_mode" {
  type    = string
  default = "bridge"
}
variable "compatibilities" {
  type    = list(string)
  default = ["EC2"]
}
variable "cpu" {
  type = map(number)
  default = {
    "default" = 350
    "dev"     = 400
    "prd"     = 700
  }
}
variable "container_name1" {
  type    = string
  default = "nginxVala"
}
variable "container_image1" {
  type      = string
  sensitive = true
  default   = "nginx:latest"
}
variable "essential1" {
  type    = bool
  default = true
}
variable "container_memory1" {
  type = map(number)
  default = {
    "default" = 250
    "dev"     = 280
    "prd"     = 300
  }
}
variable "container_cpu1" {
  type = map(number)
  default = {
    "default" = 250
    "dev"     = 250
    "prd"     = 300
  }
}
variable "con_port1" {
  type    = number
  default = 80
}
variable "protocol1" {
  type    = string
  default = "TCP"
}
variable "readOnlyRootFilesystem1" {
  type    = bool
  default = false
}
variable "container_name2" {
  type    = string
  default = "vuln_prism"
}
variable "container_image2" {
  type      = string
  sensitive = true
  default   = "furkhan2000/shark:091cd86-vulnmain"
}
variable "essential2" {
  type    = bool
  default = true
}
variable "container_memory2" {
  type = map(number)
  default = {
    "default" = 250
    "dev"     = 280
    "prd"     = 300
  }
}
variable "container_cpu2" {
  type = map(number)
  default = {
    "default" = 250
    "dev"     = 250
    "prd"     = 300
  }
}
variable "con_port2" {
  type    = number
  default = 3000
}
variable "protocol2" {
  type    = string
  default = "TCP"
}
variable "readOnlyRootFilesystem2" {
  type    = bool
  default = false
}
variable "desired_count" {
  type = map(number)
  default = {
    "default" = 1
    "dev"     = 1
    "prd"     = 2
  }
}
variable "launch_type" {
  type    = string
  default = "EC2"
}

variable "placement_strategy_type1" {
  type    = string
  default = "binpack"
}
variable "placement_strategy_type2" {
  type    = string
  default = "spread"
}
variable "placement_strategy_field1" {
  type    = string
  default = "memory"
}
variable "placement_strategy_field2" {
  type    = string
  default = "attribute:ecs.availability-zone"
}
variable "availability_zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1d"]
}
variable "asg_name" {
  type    = string
  default = "ecs_HYD_asg"
}
variable "min_size" {
  type = map(number)
  default = {
    "default" = 1
    "dev"     = 1
    "prd"     = 2
  }
}
variable "max_size" {
  type = map(number)
  default = {
    "default" = 2
    "dev"     = 2
    "prd"     = 3
  }
}
variable "desired_capacity" {
  type = map(number)
  default = {
    "default" = 1
    "dev"     = 1
    "prd"     = 2
  }
}

variable "instance_type" {
  type = map(string)
  default = {
    "default" = "t2.micro"
    "dev"     = "t2.micro"
    "prd"     = "t2.medium"
  }
}

variable "iam_instance_type" {
  type    = string
  default = "ecsInstanceLaunch"
}

variable "ecs_sg" {
  type    = string
  default = "ecs-securityGRP"
}
variable "task_exec" {
  type    = string
  default = "ecsTaskExecApple"
}
