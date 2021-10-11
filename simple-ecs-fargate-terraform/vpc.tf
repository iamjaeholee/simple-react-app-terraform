# VPC setups
resource "aws_vpc" "squid" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  
  tags = {
    Name = "squid"
  } 
}

resource "aws_security_group" "squid" {
  name        = "squid-security-group"
  vpc_id      = aws_vpc.squid.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_default_network_acl" "squid" {
  default_network_acl_id = aws_vpc.squid.default_network_acl_id

  depends_on = [
    aws_vpc.squid
  ]

  subnet_ids = [
    aws_subnet.squid-publica.id,
    aws_subnet.squid-publicb.id
  ]

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
}

resource "aws_subnet" "squid-publica" {
  depends_on = [
    aws_vpc.squid
  ]

  availability_zone = "ap-northeast-2a"
  vpc_id = aws_vpc.squid.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "publica"
  }
}

resource "aws_subnet" "squid-publicb" {
  depends_on = [
    aws_vpc.squid
  ]

  availability_zone = "ap-northeast-2b"
  vpc_id = aws_vpc.squid.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "publicb"
  }
}

resource "aws_internet_gateway" "squid" {
  vpc_id = aws_vpc.squid.id

  tags = {
    Name = "squid"
  }
}

resource "aws_route_table" "squid" {
  vpc_id = aws_vpc.squid.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.squid.id
  }

  tags = {
    Name = "squid-route-table"
  }
}

resource "aws_main_route_table_association" "squid" {
  vpc_id         = aws_vpc.squid.id
  route_table_id = aws_route_table.squid.id
}

