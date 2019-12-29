resource "aws_vpc" "mikey_test" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name       = "mikey_test"
    le-service = "Test ELB Private Link"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mikey_test.id
  tags = {
    Name = "igw"
  }
}

resource "aws_network_interface" "nat-ip" {
  subnet_id  = aws_subnet.publica.id
  depends_on = [aws_subnet.publica]
}

resource "aws_eip" "nateip" {
  vpc                       = true
  associate_with_private_ip = aws_network_interface.nat-ip.private_ip
  depends_on                = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nateip.id
  subnet_id     = aws_subnet.publica.id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "publica" {
  vpc_id                  = aws_vpc.mikey_test.id
  cidr_block              = var.publica
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "publica"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "publicb" {
  vpc_id                  = aws_vpc.mikey_test.id
  cidr_block              = var.publicb
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"

  tags = {
    Name = "publicb"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "priv_puba" {
  vpc_id            = aws_vpc.mikey_test.id
  cidr_block        = var.pub_priva
  availability_zone = "${var.region}a"

  tags = {
    Name = "priv_puba"
  }
}

resource "aws_subnet" "priv_pubb" {
  vpc_id            = aws_vpc.mikey_test.id
  cidr_block        = var.pub_privb
  availability_zone = "${var.region}b"

  tags = {
    Name = "priv_pubb"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mikey_test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "publica" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.publica.id
}

resource "aws_route_table_association" "publicb" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.publicb.id
}

resource "aws_route_table" "pub_priv" {
  vpc_id = aws_vpc.mikey_test.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "pub_priv"
  }
}

resource "aws_route_table_association" "pub_priva" {
  route_table_id = aws_route_table.pub_priv.id
  subnet_id      = aws_subnet.priv_puba.id
}

resource "aws_route_table_association" "pub_privb" {
  route_table_id = aws_route_table.pub_priv.id
  subnet_id      = aws_subnet.priv_pubb.id
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.mikey_test.id
  subnet_ids = [
    aws_subnet.publica.id,
    aws_subnet.publicb.id,
  ]
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    from_port  = 0
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    from_port  = 0
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "public"
  }
}

resource "aws_security_group" "http" {
  vpc_id      = aws_vpc.mikey_test.id
  name        = "http"
  description = "http"

  ingress {
    protocol    = "tcp"
    self        = true
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "http"
  }
}

