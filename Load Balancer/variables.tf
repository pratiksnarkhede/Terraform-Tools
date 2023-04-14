variable "ec2_instance_type" {
  description = "Ec2 instance type "
  type        = string
}

variable "cidr_block" {
    type = list(string)
    default = ["10.0.0.0/16", "10.0.1.0/24","10.0.2.0/24"]
 }

# variable "availability_zones" {
#   type =string

# }

#variable "availability_zones" {
 # type    = list(string)
  #default = ["us-west-2a", "us-west-2b", "us-west-2c"]
#}