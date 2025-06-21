# VPC
resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, {})

  lifecycle {
    prevent_destroy = false
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gtw" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "particle-dk k8s"
    Env  = "Development"
  }
}

# Public Subnet in AZ a
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.subnets[0]
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "public-1a" })
}

# Public Subnet in AZ b
resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.subnets[1]
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "public-1b" })
}

# Private Subnet in AZ a
resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.subnets[2]
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags                    = merge(var.tags, { Name = "private-1a" })
}

# Private Subnet in AZ b
resource "aws_subnet" "private_1b" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.subnets[3]
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags                    = merge(var.tags, { Name = "private-1b" })
}

# NAT Gateway (in public_1a)
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1a.id

  depends_on = [
    aws_internet_gateway.gtw,
    aws_eip.nat
  ]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtw.id
  }

  tags = merge(var.tags, { Name = "public-rt" })
}

# Associate public subnets with public RT
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id

  depends_on = [aws_route_table.public]
}

resource "aws_route_table_association" "public_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(var.tags, { Name = "private-rt" })
}

# Associate private subnets with private RT
resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private.id
}

# Security Group
resource "aws_security_group" "cluster-sg" {
  name        = var.sg_name
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.default.id
  tags        = merge(var.tags, {})

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SG rule for API server access
resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster-sg.id
  description       = "Allow workstation to communicate with the cluster API Server"

  cidr_blocks = [
    var.workstation-external-cidr,
  ]
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow inbound HTTP/HTTPS"
  vpc_id      = aws_vpc.default.id
  tags        = merge(var.tags, { Name = "alb-sg" })

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
