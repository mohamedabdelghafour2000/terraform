# CREATE A VPC
resource "aws_vpc" "app-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "app-VPC"
  }
}

# CREATE AN INTERNET GATEWAY
resource "aws_internet_gateway" "app-igw" {
  vpc_id = aws_vpc.app-vpc.id
  tags = {
    Name = "app-IGW"
  }
}

# CREATE ELASTIC IP
resource "aws_eip" "app-eip" {
  domain   = "vpc"
}

# CREATE NAT IN THE FIRST PUBLIC SUBNET
resource "aws_nat_gateway" "app-nat" {
  allocation_id = aws_eip.app-eip.id
  subnet_id     = var.nat_subnet_id
  tags = {
    Name = "app-NAT"
  }
  # To ensure proper ordering, i will add an explicit dependency on the Internet Gateway.
  depends_on = [aws_internet_gateway.app-igw]
}