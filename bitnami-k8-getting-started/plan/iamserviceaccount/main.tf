resource aws_iam_role "role" {
  name = "${var.clustername}-iamserviceaccountrole"
  assume_role_policy = templatefile("${path.module}/trust.tpl",
  {
  }
  )
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.role.name
}