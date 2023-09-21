# Define your Auto Scaling Group
resource "aws_autoscaling_group" "ec2-asg" {
  name                      = "ec2-asg"
  launch_configuration      = aws_launch_configuration.ec2.name
  vpc_zone_identifier       = [aws_subnet.my_subnet.id, aws_subnet.my_Subnet2.id]
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300

  target_group_arns = [aws_lb_target_group.ec2-tg.arn]  # Attach the target group
  

}

# Launch Configuration for EC2 instances
resource "aws_launch_configuration" "ec2" {
  name_prefix                 = "web-app"
  image_id                    = "ami-053b0d53c279acc90" 
  instance_type               = "t2.micro"
  key_name                    = "awskeys"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.my_security_group.id]
  user_data                   = file("script.sh")
}

# ALB and Target Group
resource "aws_lb" "ec2-alb" {
  name               = "ec2-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_security_group.id]
  subnets            = [aws_subnet.my_subnet.id, aws_subnet.my_Subnet2.id]
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

# Creating target group
resource "aws_lb_target_group" "ec2-tg" {
  name     = "ec2-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

# Creating listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ec2-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ec2-tg.arn
    type             = "forward"
  }
}

