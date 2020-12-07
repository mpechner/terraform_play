resource "aws_eks_cluster" "cluster" {
  name     = "bitnami-wp"
  role_arn = data.aws_iam_role.k8.arn

  vpc_config {
    subnet_ids = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id ]
  }

}

output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}
output "name" {
  value = aws_eks_cluster.cluster.name
}
output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}