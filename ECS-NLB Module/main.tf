resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"
}
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "my_ecs_task"
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]  
  cpu                      = "256" 
  memory                   = "512" 
  container_definitions  = <<EOF
[
  {
    "name": "nginx",
    "image": "public.ecr.aws/r6u3b1w3/nginx:latest",
    "cpu": 256,
    "memoryReservation": 512,
    "essential": true,
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOF
}


# Create the ECS service
resource "aws_ecs_service" "ecs_service" {
  name            = "my-ecs-service"  
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1  
  launch_type     = "FARGATE" 
   

  network_configuration {
    subnets         = [aws_subnet.my_subnet.id]
    security_groups = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }
   depends_on = [aws_ecs_task_definition.ecs_task_definition]

    load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "nginx"
    container_port   = 80
  }

}
