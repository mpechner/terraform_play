resource "aws_security_group" "bastion" {
  vpc_id = data.aws_vpc.mikey_test.id
  name = "bastion"
  description = "bastion"

  ingress {
    protocol = "tcp"
    self = true
    from_port = 22
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion"
  }
}

resource "aws_instance" "public" {
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  iam_instance_profile        = data.aws_iam_instance_profile.bastion.name
  instance_type               = "t2.micro"
  key_name                    = var.defaultkey
  vpc_security_group_ids = [
    aws_security_group.bastion.id,
  ]
  subnet_id = data.aws_subnet.publica.id
  tags = {
    Name = "bastion"
  }
  user_data = file("user_data/user_data.sh")
}

