resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"
}
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "my_ecs_task"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  container_definitions  = file("${path.module}/container-definition.json")
  requires_compatibilities = ["FARGATE"]  
  cpu                      = "256" 
  memory                   = "512" 
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

}
