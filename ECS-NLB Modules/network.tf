# Create the VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  

  tags = {
    Name = "my-vpc" 
  }
}

# Create the subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.5.0/24"   
  tags = {
    Name = "my-subnet"  
}
depends_on = [ aws_vpc.my_vpc ]
}

# # Create the subnet private
# resource "aws_subnet" "private_subnet" {
#   vpc_id            = aws_vpc.my_vpc.id
#   cidr_block        = "10.0.6.0/24"   
#   tags = {
#     Name = "private-subnet"  
# }
# }

#create Internet Gateway
resource "aws_internet_gateway" "MyIGW" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyIGW"
  }
}

# Create Route table and associate it with subnet 
resource "aws_route_table" "Public_RouteTable" {
  vpc_id = aws_vpc.my_vpc.id
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
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.Public_RouteTable.id
}

# Create the network security group
resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs_service_sg" 
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
     from_port   = 80
    to_port     = 80
     protocol = "tcp"
    #  protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
     protocol = "tcp"
    # protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

