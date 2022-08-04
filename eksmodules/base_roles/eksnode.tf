resource "aws_iam_role" "node_role" {
  name = "${var.rolename}_node"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = templatefile("${path.module}/assumerole.json.tpl", { service="ecs", sid="EKSNodeTrust"})
  description = var.cluster_description

  tags = {
    name = var.rolename
  }
}

resource aws_iam_role_policy_attachment "AmazonEKSWorkerNodePolicy" {
  role = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource aws_iam_role_policy_attachment "AmazonEC2ContainerRegistryReadOnly" {
  role = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource aws_iam_role_policy_attachment "AmazonEKS_CNI_Policy" {
  role = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
