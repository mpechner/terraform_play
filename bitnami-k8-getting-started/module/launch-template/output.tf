output "name" {
  value = aws_launch_template.eks_node.name
}
output "version" {
  value = aws_launch_template.eks_node.latest_version
}