variable "myregion" {
  default = "us-east-1"
}

variable "accountId" {
  default = "<Account_id>" # Replace Account_id with your Account id
}


# Define your custom domain name
variable "custom_domain_name" {
  default = "<domain_name>" # Replace domain_name with your domain name
}

# Define your existing SSL certificate ARN
variable "ssl_certificate_arn" {
  default = "<certificate arn>"  # Replace with your SSL certificate ARN
}

# Define your hosted zone ID
variable "hosted_zone_id" {
  default = "<hosted_zone>"  # Replace with your hosted zone ID
}

