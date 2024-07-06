
resource "aws_vpc" "vpcforwebservers" {
  
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

tags = {
  Name = "vpcforwebservers"
}

}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.vpcforwebservers.id
    #count = length(data.aws_availability_zones.az_available.names)
    #availability_zone = data.aws_availability_zones.az_available.names[count.index]
    count = length(var.availability_zoneslist)
    #availability_zone = var.availability_zoneslist[count.index]
    availability_zone = element(var.availability_zoneslist,count.index)
    map_public_ip_on_launch = true
    
    cidr_block = cidrsubnet(var.cidr_block,8,count.index*2)
    tags = {
        Name = "public subnet-${count.index+1}"
    }

}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpcforwebservers.id
   # count = length(data.aws_availability_zones.az_available.names)
   # availability_zone = data.aws_availability_zones.az_available.names[count.index]
   #availability_zone = var.availability_zoneslist[count.index]
   count = length(var.availability_zoneslist)
   availability_zone = element(var.availability_zoneslist,count.index)
   map_public_ip_on_launch = false
    
   cidr_block = cidrsubnet(var.cidr_block,8,count.index*2+1)

   tags = {
     Name = "private subnet-${count.index+1}"
   }
}

resource "aws_internet_gateway" "igw_vpc" {
  vpc_id = aws_vpc.vpcforwebservers.id
  tags = {
    Name = "IGWforVPC"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpcforwebservers.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_vpc.id
  }

  tags = {
    Name = "public route table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  route_table_id = aws_route_table.public_route_table.id
  count = length(aws_subnet.public_subnet)
  subnet_id = element(aws_subnet.public_subnet[*].id,count.index)
  #count = length(var.availability_zoneslist)
  #subnet_id = aws_subnet.public_subnet[count.index].id
}

resource "aws_eip" "eip" {
  domain = "vpc"
  depends_on = [ aws_internet_gateway.igw_vpc ]
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id = element(aws_subnet.public_subnet[*].id,0)
  allocation_id = aws_eip.eip.id
  depends_on = [ aws_internet_gateway.igw_vpc ]
  tags = {
    Name = "NAT gateway"
  }
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpcforwebservers.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "private route table"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  route_table_id = aws_route_table.private_route_table.id
  #count = length(var.availability_zoneslist)
  #subnet_id = aws_subnet.private_subnet[count.index].id
  count = length(aws_subnet.private_subnet)
  subnet_id = element(aws_subnet.private_subnet[*].id,count.index)
  
  
}

