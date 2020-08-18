
resource "aws_vpc" "default-vpc"{
  cidr_block = "192.168.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "default-subnets"{
  count                   = length(var.AVAILABILITY_ZONES)
  availability_zone       = element(var.AVAILABILITY_ZONES, count.index)
  cidr_block              = element(var.SUBNETS_CIDR,count.index)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.default-vpc.id

  tags = {
    name = "default-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "default-igw" {
  vpc_id = aws_vpc.default-vpc.id

  tags = {
    name = "default-igw"
  }
}

data "aws_subnet_ids" "subnet_ids" {
  depends_on = [aws_subnet.default-subnets]
  vpc_id     = aws_vpc.default-vpc.id
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.default-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default-igw.id
  }

  tags = {
    name = "route table"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.AVAILABILITY_ZONES)
  subnet_id = sort(data.aws_subnet_ids.subnet_ids.ids)[count.index]
  route_table_id = aws_route_table.public-route.id
}

# create elastic IP (EIP) to assign it the NAT Gateway
resource "aws_eip" "default-eip" {
  vpc      = true
  depends_on = [aws_internet_gateway.default-igw]
}
