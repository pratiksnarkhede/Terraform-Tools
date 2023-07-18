# Create the network load balancer
resource "aws_lb" "nlb" {
  name               = "ecs-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.my_subnet.id]
  #security_groups    = [aws_security_group.nlb_sg.id]
}

# Create the target group for the ECS service
resource "aws_lb_target_group" "ecs_target_group" {
  name        = "ecs-target-group"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.my_vpc.id
}

# Create the listener for the target group
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}

# Add rules to the security group for the NLB
# resource "aws_security_group_rule" "nlb_ingress_rule" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "TCP"
# #   security_group_id = aws_security_group.nlb_sg.id
#   source_security_group_id = aws_security_group.ecs_service_sg.id
# }

# # Attach the security group to the NLB
# resource "aws_security_group" "nlb_sg" {
#   vpc_id = aws_vpc.my_vpc.id
#   tags = {
#     Name = "nlb-security-group"
#   }
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "TCP"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
