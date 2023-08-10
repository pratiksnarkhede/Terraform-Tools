
# module "ECR" {
#   source       = "./ECR"
#  ecr_repo_name = var.ecr_repo_name
# }

resource "aws_batch_compute_environment" "batch" {
  compute_environment_name = "my-project-compute-env"
  
  compute_resources {
    max_vcpus = 256
    security_group_ids = [
      aws_security_group.batch.id,
    ]
    # subnets = data.aws_subnet_ids.all_default_subnets.ids
    subnets = aws_subnet.Public_subnet[*].id
    type = "FARGATE"
  }
  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  depends_on = [
    aws_iam_role_policy_attachment.aws_batch_service_role
  ]
}

resource "aws_batch_job_queue" "batch" {
  name     = "my-project-job-queue"
  state    = "ENABLED"
  priority = "0"
  compute_environments = [
    aws_batch_compute_environment.batch.arn,
  ]
}

resource "aws_batch_job_definition" "batch" {
  name = "my-job-definition"
  type = "container"
  platform_capabilities = [
    "FARGATE",
  ]
  container_properties = jsonencode({
    command = ["echo", "test"]
    image   = "438233270299.dkr.ecr.us-east-1.amazonaws.com/python:latest"

    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    networkConfiguration = {
      assignPublicIp = "ENABLED"
    }

    resourceRequirements = [
      {
        type  = "VCPU"
        value = "0.25"
      },
      {
        type  = "MEMORY"
        value = "512"
      }
    ]

    executionRoleArn = aws_iam_role.aws_ecs_task_execution_role.arn
  })
}