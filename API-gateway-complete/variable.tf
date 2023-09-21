variable "myregion" {
  default = "us-east-1"
}

variable "accountId" {
  default = "438233270299"
}


# Define your custom domain name
variable "custom_domain_name" {
  default = "mywebapplication.me" 
}

# Define your existing SSL certificate ARN
variable "ssl_certificate_arn" {
  default = "arn:aws:acm:us-east-1:438233270299:certificate/01cbf241-03ed-4d6f-a505-133f2321c8ed"  # Replace with your SSL certificate ARN
}

# Define your hosted zone ID
variable "hosted_zone_id" {
  default = "Z028009242LYGS6EC2PA"  # Replace with your hosted zone ID
}

