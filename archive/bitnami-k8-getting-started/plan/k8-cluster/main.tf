resource "aws_eks_cluster" "cluster" {
  name     = "bitnami-wp"
  role_arn = data.aws_iam_role.k8.arn

  vpc_config {
    subnet_ids = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id ]
  }

}


resource aws_iam_openid_connect_provider "oidcprovider"{
  url = aws_eks_cluster.cluster.identity[0]["oidc"][0]["issuer"]
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = []
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
output "oidc_http" {
  value = aws_eks_cluster.cluster.identity[0]["oidc"][0]["issuer"]
}
output "oidc_arn" {
  value = aws_iam_openid_connect_provider.oidcprovider.arn
}
output "odidc_url" {
  value = aws_iam_openid_connect_provider.oidcprovider.url
}

resource aws_iam_role "cnirole" {
  name = "${aws_eks_cluster.cluster.name}-iamserviceaccountrole"
  assume_role_policy = templatefile("${path.cwd}/trust.tfl",
  {
    oidc_arn = aws_iam_openid_connect_provider.oidcprovider.arn
    oidc_url = aws_iam_openid_connect_provider.oidcprovider.url
  }
  )
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.cnirole.name
}