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
  id = "subnet-071f296ad5cb1996d"
  vpc_id = "vpc-1fe9ec64"
}

data aws_subnet subnet2 {
  id = "subnet-09422dd3e1c1b80a9"
  vpc_id = "vpc-1fe9ec64"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data aws_security_group "sg"{
  name = "eks-node-access"
}

module "launchgroup" {
  source = "../../module/launch-template"
  template_name = "wp1"
  iam_instance_profile = ""
  security_groups = [ data.aws_security_group.sg.id]
  cluster_ca = data.terraform_remote_state.eks-cluster.outputs.kubeconfig-certificate-authority-data
  cluster_endpoint =data.terraform_remote_state.eks-cluster.outputs.endpoint
  cluster_name = data.terraform_remote_state.eks-cluster.outputs.name
  ami = var.ami
  node_group = var.group_name
}



resource aws_eks_node_group nodes{
  cluster_name =  data.terraform_remote_state.eks-cluster.outputs.name
  node_group_name = var.group_name
  launch_template {
    id = module.launchgroup.id
    version = module.launchgroup.version
  }
  node_role_arn = "arn:aws:iam::990880295272:role/bn_k8_node_svc_role"
  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.small"]
  subnet_ids = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]
  tags = {
    "KubernetesCluster" = data.terraform_remote_state.eks-cluster.outputs.name
    "Name" = data.terraform_remote_state.eks-cluster.outputs.name
  }
  labels = {
    "KubernetesCluster" = data.terraform_remote_state.eks-cluster.outputs.name
    "Name" = data.terraform_remote_state.eks-cluster.outputs.name
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
