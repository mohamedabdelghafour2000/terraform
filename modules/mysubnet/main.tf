resource "aws_subnet" "pub_subnets" {
  count             = length(var.pub_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = var.pub_subnets[count.index].subnets_cidr
  availability_zone = var.pub_subnets[count.index].availability_zone
  tags = {
    Name = "public_subnet_${count.index}"
  }
}

resource "aws_route_table" "pub-rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
}

resource "aws_route_table_association" "pub-rt" {
  count          = length(aws_subnet.pub_subnets)
  subnet_id      = aws_subnet.pub_subnets[count.index].id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_subnet" "priv_subnets" {
  count             = length(var.priv_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = var.priv_subnets[count.index].subnets_cidr
  availability_zone = var.priv_subnets[count.index].availability_zone
  tags = {
    Name = "private_subnet_${count.index}"
  }
}

resource "aws_route_table" "priv-rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_id
  }
}

resource "aws_route_table_association" "priv-rt" {
  count          = length(aws_subnet.priv_subnets)
  subnet_id      = aws_subnet.priv_subnets[count.index].id   
  route_table_id = aws_route_table.priv-rt.id
}





