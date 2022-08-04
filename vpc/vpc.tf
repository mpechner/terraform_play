resource aws_vpc_dhcp_options "demo_dhcpoptions" {
  domain_name_servers = ["AmazonProvidedDNS"]
  domain_name = "ec2.internal"
  tags = {
    Name = "demo_dhcp_options"
  }
}
resource "aws_vpc" "demo" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name       = "demo"
  }
}
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.demo.id
  dhcp_options_id = aws_vpc_dhcp_options.demo_dhcpoptions.id
}
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = var.eks_cidr
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo.id
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
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = var.publica
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "publica"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "publicb" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = var.publicb
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"

  tags = {
    Name = "publicb"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "publicc" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = var.publicc
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}c"

  tags = {
    Name = "publicc"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "priv_puba" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = var.pub_priva
  availability_zone = "${var.region}a"

  tags = {
    Name = "priv_puba"
  }
}

resource "aws_subnet" "priv_pubb" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = var.pub_privb
  availability_zone = "${var.region}b"

  tags = {
    Name = "priv_pubb"
  }
}

resource "aws_subnet" "priv_pubc" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = var.pub_privc
  availability_zone = "${var.region}c"

  tags = {
    Name = "priv_pubc"
  }
}

resource "aws_subnet" "priv_puba_eks" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = var.pub_priva_eks
  availability_zone = "${var.region}a"

  tags = {
    Name = "priv_puba_eks"
  }
}

resource "aws_subnet" "priv_pubb_eks" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = var.pub_privb_eks
  availability_zone = "${var.region}b"

  tags = {
    Name = "priv_pubb_eks"
  }
}

resource "aws_subnet" "priv_pubc_eks" {
  vpc_id            = aws_vpc.demo.id
  cidr_block        = var.pub_privc_eks
  availability_zone = "${var.region}c"

  tags = {
    Name = "priv_pubc_eks"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo.id

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

resource "aws_route_table_association" "publicc" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.publicc.id
}

resource "aws_route_table" "pub_priv" {
  vpc_id = aws_vpc.demo.id
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

resource "aws_route_table_association" "pub_privc" {
  route_table_id = aws_route_table.pub_priv.id
  subnet_id      = aws_subnet.priv_pubc.id
}


resource "aws_route_table" "eks" {
  vpc_id = aws_vpc.demo.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "eks"
  }
}

resource "aws_route_table_association" "eks_a" {
  route_table_id = aws_route_table.eks.id
  subnet_id      = aws_subnet.priv_puba_eks.id
}

resource "aws_route_table_association" "eks_b" {
  route_table_id = aws_route_table.eks.id
  subnet_id      = aws_subnet.priv_pubb_eks.id
}

resource "aws_route_table_association" "eks_c" {
  route_table_id = aws_route_table.eks.id
  subnet_id      = aws_subnet.priv_pubc_eks.id
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.demo.id
  subnet_ids = [
    aws_subnet.publica.id,
    aws_subnet.publicb.id,
    aws_subnet.publicc.id,
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
resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.demo.id
  subnet_ids = [
    aws_subnet.priv_puba.id,
    aws_subnet.priv_pubb.id,
    aws_subnet.priv_pubc.id,
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
    Name = "private"
  }
}

resource "aws_network_acl" "eks" {
  vpc_id = aws_vpc.demo.id
  subnet_ids = [
    aws_subnet.priv_puba_eks.id,
    aws_subnet.priv_pubb_eks.id,
    aws_subnet.priv_pubc_eks.id,
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
    Name = "eks"
  }
}