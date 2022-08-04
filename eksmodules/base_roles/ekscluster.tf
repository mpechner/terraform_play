resource "aws_iam_role" "eks_role" {
  name = var.rolename

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = templatefile("${path.module}/assumerole.json.tpl", { service="eks", sid="EKSTrust"})
  description = var.cluster_description

  tags = {
    name = var.rolename
  }
}

resource aws_iam_role_policy_attachment "eks_svc"{
  role = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

