# EKS Cluster
resource "aws_eks_cluster" "mustang" {
  name     = var.eks_cluster
  role_arn = aws_iam_role.porsche.arn
  version  = "1.33"

access_config {
  authentication_mode = "API"
} 
      #### ITS EKS MANAGED AND LILL EXPENSIVE< ITS NOT SELF MANAGED its eks managed node group 
  vpc_config {
    subnet_ids              = data.aws_subnets.default.ids
    endpoint_private_access = var.priendpoint_access
    endpoint_public_access  = var.pubendpoint_access
    public_access_cidrs     = var.pub_cidr
  }

  depends_on = [aws_iam_role_policy_attachment.eks_clust_policy]
}

# EKS Node Group
resource "aws_eks_node_group" "worker_agent" {
  cluster_name    = aws_eks_cluster.mustang.name
  node_group_name = var.worker_agent_name[terraform.workspace]
  node_role_arn   = aws_iam_role.porsche-node.arn
  subnet_ids      = data.aws_subnets.default.ids

  capacity_type  = var.capacity_type
  instance_types = var.instance_type

  scaling_config {
    desired_size = var.desired_size[terraform.workspace]
    max_size     = var.max_size[terraform.workspace]
    min_size     = var.min_size[terraform.workspace]
  }

  update_config {
    max_unavailable = var.unavailable_node
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_worker_node_minimal_policy,
    aws_iam_role_policy_attachment.node_container_registry_pull_only,
    aws_iam_role_policy_attachment.node_cni_policy,
    aws_iam_role_policy_attachment.node_ec2_readonly_policy,
  ]
}

# VPC and Subnet Configuration
resource "aws_default_vpc" "perplexity" {
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.perplexity.id]
  }
  filter {
    name   = "availability-zone"
    values = var.availability_zone
  }
}
