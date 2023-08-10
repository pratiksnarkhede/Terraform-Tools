# # Retrieves the default vpc for this region
# data "aws_vpc" "default" {
#   default = true
# }

# # Retrieves the subnet ids in the default vpc
# data "aws_subnet_ids" "all_default_subnets" {
#   vpc_id = data.aws_vpc.default.id
# }

# Create the VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  

  tags = {
    Name = "my-vpc" 
  }
}


# Create the subnet
resource "aws_subnet" "Public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.5.0/24"   
  tags = {
    Name = "my-subnet"  
}
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

#create public association
resource "aws_route_table_association" "Public_Association" {
  subnet_id      = aws_subnet.Public_subnet.id
  route_table_id = aws_route_table.Public_RouteTable.id
}

resource "aws_security_group" "batch" {

  name   = "batch"
#   vpc_id = data.aws_vpc.default.id
    vpc_id = aws_vpc.my_vpc.id
  description = "batch VPC security group"
  
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}