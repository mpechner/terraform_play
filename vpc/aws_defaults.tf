resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.demo.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "default"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.demo.default_route_table_id

  tags = {
    Name = "default table"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.demo.id

  ingress {
    protocol    = -1
    self        = true
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "default"
  }
}

#resource "aws_default_vpc_dhcp_options" "default" {
#  tags = {
#    Name = "Default DHCP Option Set"
#  }
#}

