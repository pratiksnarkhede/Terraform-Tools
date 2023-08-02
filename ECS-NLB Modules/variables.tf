variable "region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"
}

# variable "vpc_id" {
#   description = "VPC ID"
#   type        = string
# }
variable "vpc_cidr" {
  description = "CIDR range of VPC"
  type        = string
  default     = "10.0.0.0/16"
}


# variable "ecs_cluster_name" {
#   description = "ECS cluster name"
#   type        = string
# }

variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
  default = "ecs-service"
}

