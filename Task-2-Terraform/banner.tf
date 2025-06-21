resource "null_resource" "dhruv_banner" {
  provisioner "local-exec" {
    when    = create
    command = <<EOT
echo ""
echo "╔════════════════════════════════════════════╗"
echo "║      🚀 THIS CODE WAS WRITTEN BY          ║"
echo "║         ✨ DHRUV KR SHARMA ✨              ║"
echo "╚════════════════════════════════════════════╝"
EOT
  }
  depends_on = [aws_eks_node_group.default]
}