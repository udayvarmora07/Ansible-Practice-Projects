resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    "Name" = "test_vpc_uday"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "test_igw_uday"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = "ap-south-1a"

  tags = {
    "Name" = "public_subnet_uday"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = "ap-south-1b"

  tags = {
    "Name" = "private_subnet_uday"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "public_rt_uday"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "private_rt_uday"
  }
}

resource "aws_route_table_association" "private_rt_association" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet.id
}