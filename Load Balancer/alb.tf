resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG_EC2.id]
  subnets            = [aws_subnet.Public-Subnet.id,aws_subnet.Public-Subnet2.id]
  

  enable_deletion_protection = false



  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "test" {
  name       = "tf-example-lb-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.Public-VPC.id
}

#resource "aws_vpc" "main" {
  #cidr_block = "10.0.0.0/16"
#}



resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.test.arn
    port = 80
    protocol = "HTTP"

    # Default 
    default_action {
        target_group_arn = aws_lb_target_group.test.arn
        type = "forward"
        }
    }


# Attach the target group for "test" ALB

resource "aws_lb_target_group_attachment" "tg_attachment_test"{
    count            = length(aws_instance.vm-web)
    target_group_arn = aws_lb_target_group.test.arn
    target_id        = aws_instance.vm-web[count.index].id
    port             = 80

}
