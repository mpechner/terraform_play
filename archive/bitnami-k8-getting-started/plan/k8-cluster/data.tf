data aws_iam_role "k8"{
  name = "bn_k8_svc_role"
}

data aws_subnet subnet1 {
  id = "subnet-071f296ad5cb1996d"
  vpc_id = "vpc-1fe9ec64"
}

data aws_subnet subnet2 {
  id = "subnet-09422dd3e1c1b80a9"
  vpc_id = "vpc-1fe9ec64"
}

