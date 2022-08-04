resource "aws_security_group" "allow_tls" {
  name        = "eks-node-access"
  description = "Allow access to eks nodes"
  vpc_id      = "vpc-1fe9ec64"

  ingress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-node-access"
    "kubernetes.io/cluster/bitnami-wp" = "owned"
  }
}