# # -------------------------------
# # Add-ons for EKS Cluster
# # -------------------------------

resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.default.name
  addon_name    = "vpc-cni"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

# resource "aws_eks_addon" "coredns" {
#   cluster_name  = aws_eks_cluster.default.name
#   addon_name    = "coredns"
#   resolve_conflicts = "OVERWRITE"
# }

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.default.name
  addon_name    = "kube-proxy"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

}

# resource "aws_eks_addon" "ebs_csi" {
#   cluster_name  = aws_eks_cluster.default.name
#   addon_name    = "aws-ebs-csi-driver"
#   resolve_conflicts = "OVERWRITE"
# }

