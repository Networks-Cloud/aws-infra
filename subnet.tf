data "aws_availability_zones" "example" {
  state = "available"
}

locals {
  azs = data.aws_availability_zones.example.names
}


resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.vishal.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true
  depends_on = [
    aws_vpc.vishal,
    aws_internet_gateway.gateway
  ]

  tags = {
    "Name" = "Public subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.vishal.id
  cidr_block              = "10.0.${count.index + 4}.0/24"
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = false

  depends_on = [
    aws_vpc.vishal,
    aws_internet_gateway.gateway
  ]

  tags = {
    "Name" : "Private subnet"
  }
}
