resource "aws_iam_role" "role" {
  name = "bn_k8_svc_role"

assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "bitnamiK8Example"
    }
  ]
}
EOF
}
data "aws_iam_policy" "AmazonEKSClusterPolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  role = aws_iam_role.role.name
  policy_arn = data.aws_iam_policy.AmazonEKSClusterPolicy.arn
}
data aws_iam_policy "AmazonEKSServicePolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"

}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  role = aws_iam_role.role.name
  policy_arn = data.aws_iam_policy.AmazonEKSServicePolicy.arn
}
