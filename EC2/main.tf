terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>3.0"
        }
    }
}

#configure the AWS

provider "aws"  {
    region = "us-east-1"
}
 
module "ec2_app" {
   source = "./modules/ec2"
 
   # instance_root_device_size = 12 # Optional
}
 
module "ec2_worker" {
   source = "./modules/ec2"
   
 

}



module "vpc" {
  source = "./modules/vpc"


 
  # Note we are /17, not /16
  # So we're only using half of the available
}