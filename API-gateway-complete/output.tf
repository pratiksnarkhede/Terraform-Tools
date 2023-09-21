output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.ec2-alb.dns_name
}
