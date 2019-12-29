resource "aws_iam_role" "bastion"{
  name = "bastion"
  description = "Allows EC2 instances to call AWS services on your behalf."
  assume_role_policy = file("policy_text/bastion_policy.json")
}

resource "aws_iam_instance_profile" "bastion" {
  name = "bastion"
  role = aws_iam_role.bastion.name

}

resource "aws_iam_role_policy_attachment" "EC2InstanceConnect" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
}

resource "aws_iam_role_policy_attachment" "bastion_ssh_privatekey" {
  role       = aws_iam_role.bastion.name
  policy_arn =  var.policy_bastion_ssh_privatekey
}

resource "aws_iam_role" "ecs"{
  name = "ecs"
  description = "Allows ec2 to call AWS services on your behalf."
assume_role_policy = file("policy_text/bastion_policy.json")
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs"
  role = aws_iam_role.ecs.name

}

resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy" {

  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}