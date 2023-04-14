terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}



// creating security group 

resource "aws_security_group" "SG_EC2" {
  name        = "allow ssh,http"
  description = "Allow  inbound traffic"
  vpc_id      = aws_vpc.Public-VPC.id

  ingress {
    description = "ssh,http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  depends_on = [
    aws_vpc.Public-VPC
  ]
  tags = {
    Name = "allow_http"
  }
}


resource "aws_instance" "vm-web" {
  count                       = 2
  ami                         = "ami-00c39f71452c08778"
  instance_type               = var.ec2_instance_type
  key_name                    = "awskeys"
  vpc_security_group_ids      = [aws_security_group.SG_EC2.id]
  subnet_id                   = aws_subnet.Public-Subnet.id
  associate_public_ip_address = true
  user_data                   = file("myScript.sh")


  depends_on = [
    aws_security_group.SG_EC2
  ]

}
