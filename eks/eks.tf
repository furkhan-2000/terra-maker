# EKS Cluster (Control Plane Only)
resource "aws_eks_cluster" "greenLeaving" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  
  vpc_config {
    subnet_ids = data.aws_subnets.wipro.ids
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "wipro" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name = "availability-zone"
    values = var.availability_filter
  }
}

resource "aws_security_group" "worker_sg" {
  name        = "${var.cluster_name}-worker-sg"
  description = "EKS worker node security group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = [aws_eks_cluster.greenLeaving.vpc_config[0].cluster_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.30-*"]
  }
  most_recent = true
  owners      = ["602401143452"]
  
  filter {
    name   = "architecture"
    values = var.architecture
  }
}

resource "aws_launch_template" "EKS_worker_template" {
  name_prefix   = "${var.cluster_name}-worker-"
  image_id      = data.aws_ami.eks_worker.id
  instance_type = var.instance_type[terraform.workspace]
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.worker_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.worker_profile.name
  }

  user_data = base64encode(templatefile("${path.module}/bootstrap.sh", {
    cluster_name = aws_eks_cluster.greenLeaving.name
    endpoint     = aws_eks_cluster.greenLeaving.endpoint
    ca_data      = aws_eks_cluster.greenLeaving.certificate_authority[0].data
  }))

  instance_market_options {
    market_type = "spot"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  }
}

resource "aws_autoscaling_group" "EKS_worker_asg" {
  desired_capacity    = var.desired_capacity[terraform.workspace]
  max_size            = var.max_size[terraform.workspace]
  min_size            = var.min_size[terraform.workspace]
  vpc_zone_identifier = data.aws_subnets.wipro.ids

  launch_template {
    id      = aws_launch_template.EKS_worker_template.id
    version = "$Latest"
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-worker"
    propagate_at_launch = true
  }
}
