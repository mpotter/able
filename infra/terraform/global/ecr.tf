# ECR Repository for container images

resource "aws_ecr_repository" "dotco" {
  name                 = "able-dotco"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "able-dotco"
  }
}

resource "aws_ecr_lifecycle_policy" "dotco" {
  repository = aws_ecr_repository.dotco.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
