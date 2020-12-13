data terraform_remote_state eks-cluster {
  backend="s3"
  config= {
    bucket = "mikey-com-terraformstate"
    key = "bitnami-k8-getting-started/plan/k8-cluster"
    region = "us-east-1"
    dynamodb_table = "terraform-state"
  }
}

data aws_subnet subnet1 {
  id = "subnet-04d557b24116f844e"
  vpc_id = "vpc-1fe9ec64"
}

data aws_subnet subnet2 {
  id = "subnet-0bc41bb59ac3fd51a"
  vpc_id = "vpc-1fe9ec64"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "launchgroup" {
  source = "../../module/launch-template"
  template_name = "wp1"
  iam_instance_profile = ""
  security_groups = [""]
  cluster_ca = data.terraform_remote_state.eks-cluster.outputs.kubeconfig-certificate-authority-data
  cluster_endpoint =data.terraform_remote_state.eks-cluster.endpoint
  cluster_name = data.terraform_remote_state.eks-cluster.name
  ami = ""
  node_group = var.group_name
}

resource aws_eks_node_group nodes{
  cluster_name =  data.terraform_remote_state.eks-cluster.outputs.name
  node_group_name = var.group_name
  launch_template = {
    id = module.launchgroup.name
    version = module.launchgroup.version
  }
  node_role_arn = "arn:aws:iam::990880295272:role/bn_k8_node_svc_role"
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  subnet_ids = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id ]

  instance_types = ["t3.small"]

  remote_access {
    ec2_ssh_key = "akey"
    source_security_group_ids = [ aws_security_group.allow_tls.id]
  }
}

output "arn" {
  value = aws_eks_node_group.nodes.arn
}

output "id" {
  value = aws_eks_node_group.nodes.id
}

output "clustername" {
  value = aws_eks_node_group.nodes.cluster_name
}

output "node_group_name" {
  value = aws_eks_node_group.nodes.node_group_name
}
