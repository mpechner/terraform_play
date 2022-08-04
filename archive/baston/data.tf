data "aws_vpc" "mikey_test" {
  filter {
    name = "tag:Name"
    values = [ "mikey_test" ]
  }
}


data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_iam_instance_profile" "bastion" {
  name = "bastion"
}

data "aws_subnet" "publica" {
  filter {
    name   = "tag:Name"
    values = ["publica"]
  }
}

data "aws_subnet" "priv_puba" {
  filter {
    name   = "tag:Name"
    values = ["priv_puba"]
  }
}

