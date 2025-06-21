data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.default.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.default.name
}

data "aws_caller_identity" "current" {}