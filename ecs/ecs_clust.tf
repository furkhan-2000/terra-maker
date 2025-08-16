# Cluster Creation 
resource "aws_ecs_cluster" "main-cluster" {
  name = var.ecs_cluster

  setting {
    name  = "containerInsights"
    value = var.insights
  }

  tags = {
    Environment = terraform.workspace
    Owner       = "Steve Jobs"
  }
}
# default vpc 
data "aws_vpc" "apple-vpc" {
  default = true
}
# default subnet
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.apple-vpc.id]
  }
}
# security Group 
resource "aws_security_group" "ecs_instance_sg" {
  name   = var.ecs_sg
  vpc_id = data.aws_vpc.apple-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "ecs-instance-sg"
  }
}
# dynnamic ami lookup 
data "aws_ami" "ecs-optimized-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.202*-x86_64-ebs"]
  }
}

# Templates 
resource "aws_launch_template" "ecs_apple" {
  name_prefix   = "ecs-${terraform.workspace}-"
  image_id      = data.aws_ami.ecs-optimized-ami.id
  instance_type = var.instance_type[terraform.workspace]

  user_data = base64encode(file("ecsScript.sh"))

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  vpc_security_group_ids = [aws_security_group.ecs_instance_sg.id]
}
# Auto_Scaling
resource "aws_autoscaling_group" "ecs_autoscaling" {
  name                = var.asg_name
  vpc_zone_identifier = data.aws_subnets.default.ids
  min_size            = var.min_size[terraform.workspace]
  max_size            = var.max_size[terraform.workspace]
  desired_capacity    = var.desired_capacity[terraform.workspace]

  launch_template {
    id      = aws_launch_template.ecs_apple.id
    version = "$Latest"
  }
}
# IAM for launch instance type
resource "aws_iam_role" "ecs_instance_role" {
  name = var.iam_instance_type

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecs_instance_role.name
}
