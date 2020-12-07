data aws_iam_role "k8"{
  name = "bn_k8_svc_role"
}

data aws_subnet subnet1 {
  id = "subnet-04d557b24116f844e"
  vpc_id = "vpc-1fe9ec64"
}

data aws_subnet subnet2 {
  id = "subnet-0bc41bb59ac3fd51a"
  vpc_id = "vpc-1fe9ec64"
}

