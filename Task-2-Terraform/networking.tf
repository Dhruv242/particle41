resource "aws_vpc" "default" {
  tags       = merge(var.tags, {})
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "snet1" {
  vpc_id                  = aws_vpc.default.id
  tags                    = merge(var.tags, {})
  map_public_ip_on_launch = true
  cidr_block              = var.subnets[0]
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "snet2" {
  vpc_id                  = aws_vpc.default.id
  tags                    = merge(var.tags, {})
  map_public_ip_on_launch = false
  cidr_block              = var.subnets[1]
  availability_zone       = "us-east-1b"
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.snet1.id  # NAT in public subnet
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.snet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.snet2.id
  route_table_id = aws_route_table.private.id
}


resource "aws_internet_gateway" "gtw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "particle-dk k8s"
    Env  = "Development"
  }
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, {})

  route {
    gateway_id = aws_internet_gateway.gtw.id
    cidr_block = "0.0.0.0/0"
  }
}


resource "aws_security_group" "cluster-sg" {
  vpc_id      = aws_vpc.default.id
  tags        = merge(var.tags, {})
  name        = var.sg_name
  description = "Cluster communication with worker nodes"

  egress {
    to_port   = 0
    protocol  = "-1"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  type              = "ingress"
  to_port           = 443
  security_group_id = aws_security_group.cluster-sg.id
  protocol          = "tcp"
  from_port         = 443
  description       = "Allow workstation to communicate with the cluster API Server"

  cidr_blocks = [
    var.workstation-external-cidr,
  ]
}