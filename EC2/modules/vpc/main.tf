#Create our first VPC
resource "aws_vpc" "Public-VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Public-VPC"
  }
}

resource "aws_subnet" "Public-Subnet" {
  vpc_id            = aws_vpc.Public-VPC.id
  cidr_block        = var.cidr_block[1]
  #availability_zone = "us-east-1b"

  tags = {
    Name = "Public-Subnet"
  }
}

resource "aws_subnet" "Public-Subnet2" {
  vpc_id            = aws_vpc.Public-VPC.id
  cidr_block        = var.cidr_block[2]
  #availability_zone = "us-east-1c"
}


#create Internet Gateway
resource "aws_internet_gateway" "MyIGW" {
  vpc_id = aws_vpc.Public-VPC.id

  tags = {
    Name = "MyIGW"
  }
}

# Create Route table and associate it with subnet 
resource "aws_route_table" "Public_RouteTable" {
  vpc_id = aws_vpc.Public-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGW.id
  }
  tags = {
    Name = "MyRouteTable"
  }
}

#create association
resource "aws_route_table_association" "Public_Association" {
  subnet_id      = aws_subnet.Public-Subnet.id
  route_table_id = aws_route_table.Public_RouteTable.id
}

