data "aws_vpc" "default" {
  tags = {
    Name = "default"
  }
}
data "aws_subnet" "def_1a" {
  availability_zone = "us-east-1a"
  tags = {
    Name = "def_1a"
  }
}

