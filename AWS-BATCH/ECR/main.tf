
resource "aws_ecr_repository" "repo" {
  name = "my-public-ecr-repo"
  image_tag_mutability = "MUTABLE"
  tags = {
    Environment = "Production"
  }
}
resource "aws_ecr_repository_policy" "demo-repo-policy" {
  repository = aws_ecr_repository.repo.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the demo repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
}


output "ecr_public_repo_url" {
  value = aws_ecr_repository.public_repo.repository_url
}


