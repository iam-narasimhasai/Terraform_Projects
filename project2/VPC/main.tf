resource "aws_vpc" "vpc1" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "3tierVPC"
  }

}

resource "aws_subnet" "publicsubnet" {
  vpc_id                  = aws_vpc.vpc1.id
  count                   = 2
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zone, count.index % 2)
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index * 2)
  tags = {
    Name = "publicsubnet ${count.index}"
  }
}
resource "aws_subnet" "privatesubnet" {
  vpc_id                  = aws_vpc.vpc1.id
  count                   = 4
  map_public_ip_on_launch = false
  availability_zone       = element(var.availability_zone, count.index % 2)
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index * 2 + 1)



  tags = {
    Name = "privatesubnet ${count.index}"
  }
}
resource "aws_internet_gateway" "igw" {
  tags = {
    Name = "igwfor ${aws_vpc.vpc1.id}"
  }
}
resource "aws_internet_gateway_attachment" "name" {
  vpc_id              = aws_vpc.vpc1.id
  internet_gateway_id = aws_internet_gateway.igw.id
}
resource "aws_eip" "eip" {
  count = 2
  tags = {
    Name = "eipfonat ${count.index}"
  }
}
resource "aws_nat_gateway" "nat" {
  count         = 2
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.publicsubnet[count.index].id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "Nat ${count.index}"
  }
}
resource "aws_route_table" "publicroutetable" {
  vpc_id = aws_vpc.vpc1.id
  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Publicroutetable"
  }
}
resource "aws_route_table_association" "publicroutetableassociation" {
  count          = 2
  subnet_id      = aws_subnet.publicsubnet[count.index].id
  route_table_id = aws_route_table.publicroutetable.id

}


resource "aws_route_table" "privatesubnetforAZ1" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = aws_subnet.privatesubnet[0].cidr_block
    gateway_id = aws_nat_gateway.nat[0].id
  }
  route {
    cidr_block = aws_subnet.privatesubnet[2].cidr_block
    gateway_id = aws_nat_gateway.nat[0].id
  }
  tags = {
    Name = "PrivatesubnetforAZ1"
  }
}

resource "aws_route_table_association" "az1association" {
  count          = 2
  subnet_id      = aws_subnet.privatesubnet[count.index * 2].id
  route_table_id = aws_route_table.privatesubnetforAZ1.id
}

resource "aws_route_table" "privatesubnetforAZ2" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = aws_subnet.privatesubnet[1].cidr_block
    gateway_id = aws_nat_gateway.nat[1].id
  }
  route {
    cidr_block = aws_subnet.privatesubnet[3].cidr_block
    gateway_id = aws_nat_gateway.nat[1].id
  }
  tags = {
    Name = "privatesubnetforAZ2"
  }
}

resource "aws_route_table_association" "az2association" {
  count          = 2
  subnet_id      = aws_subnet.privatesubnet[count.index * 2 + 1].id
  route_table_id = aws_route_table.privatesubnetforAZ2.id
}
