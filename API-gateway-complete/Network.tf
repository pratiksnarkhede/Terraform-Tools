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
  cidr_block        = "10.0.1.0/24"   
  availability_zone = "us-east-1b"
  tags = {
    Name = "my-subnet"  
}
}

resource "aws_subnet" "my_Subnet2" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-east-1c"
}

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


resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  vpc_id      = aws_vpc.my_vpc.id

  # Ingress rule for port 22 (SSH)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule for port 80 (HTTP)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
