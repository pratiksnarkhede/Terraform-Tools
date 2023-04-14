
module "vpc" {
  source = "../vpc"

}


resource "aws_instance" "vm-web" {
  count                       = 1
  ami                         = "ami-00c39f71452c08778"
  instance_type               = "t2.micro"
  key_name                    = "awskeys"
  subnet_id                   = "${module.vpc.vpc_id}"
  associate_public_ip_address = true

}



