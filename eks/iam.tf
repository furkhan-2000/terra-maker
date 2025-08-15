# EKS Cluster IAM Role 
resource "aws_iam_role" "porsche" {
  name = var.iam_cluster
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# Cluster policy for self managed
resource "aws_iam_role_policy_attachment" "eks_clust_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.porsche.name
}

# Node IAM Role
resource "aws_iam_role" "porsche-node" {
  name = var.node_iam_cluster
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Node policies for self-managed
resource "aws_iam_role_policy_attachment" "node_worker_node_minimal_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
  role       = aws_iam_role.porsche-node.name
}

resource "aws_iam_role_policy_attachment" "node_container_registry_pull_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.porsche-node.name
}

resource "aws_iam_role_policy_attachment" "node_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.porsche-node.name
}

resource "aws_iam_role_policy_attachment" "node_ec2_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.porsche-node.name
}

# User access configuration
data "aws_caller_identity" "current" {}

# EKS Access entry
resource "aws_eks_access_entry" "current_lappy" {
  cluster_name  = aws_eks_cluster.mustang.name
  principal_arn = data.aws_caller_identity.current.arn
  type          = "STANDARD"
}

# AWS managed policy for admin access
resource "aws_eks_access_policy_association" "admin_policy" {
  cluster_name  = aws_eks_cluster.mustang.name
  principal_arn = data.aws_caller_identity.current.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

# Console access policy
resource "aws_iam_policy" "eks_console_access" {
  name = var.eks_console

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:AccessKubernetesApi",
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:ListUpdates",
          "eks:ListAddons",
          "eks:DescribeAddonVersions",
          "eks:ListFargateProfiles",
          "eks:ListIdentityProviderConfigs",
          "iam:ListRoles"
        ]
        Resource = "*"
      }
    ]
  })
}

# Console access attachment
locals {
  user_name = split("/", data.aws_caller_identity.current.arn)[1]
}

resource "aws_iam_user_policy_attachment" "eks_console_access" {
  user       = local.user_name
  policy_arn = aws_iam_policy.eks_console_access.arn
}
