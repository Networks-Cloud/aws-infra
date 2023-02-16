resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vishal.id
  depends_on = [
    aws_vpc.vishal
  ]
  tags = {
    "Name" = "Public Gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vishal.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    "Name" = "public route"
  }
}

resource "aws_route_table_association" "public" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vishal.id

  tags = {
    "Name" = "private route"
  }
}

resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route.id
}
