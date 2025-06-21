resource "aws_eks_node_group" "default" {
  tags            = merge(var.tags, {})
  node_role_arn   = aws_iam_role.default-iam.arn
  node_group_name = "particle-dk_k8s"
  cluster_name    = aws_eks_cluster.default.name
  instance_types  = ["t2.micro"]

  depends_on = [
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
  ]

  scaling_config {
    min_size     = var.scaling.min
    max_size     = var.scaling.max
    desired_size = var.scaling.desired
  }

  subnet_ids = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1b.id,
  ]
}


resource "aws_eks_cluster" "default" {
  role_arn = aws_iam_role.iam-cluster.arn
  name     = var.cluster-name

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController,
  ]

  tags = {
    env = "Devlopment"
  }

  vpc_config {
    security_group_ids = [
      aws_security_group.cluster-sg.id,
    ]
    subnet_ids = [
      aws_subnet.private_1a.id,
      aws_subnet.private_1b.id,
    ]
  }
}

