# GitHub OIDC Provider and IAM Role for GitHub Actions

data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-github-actions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = data.aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "github_actions" {
  name = "${var.project_name}-github-actions-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ECR - push/pull images
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:CreateRepository",
          "ecr:DeleteRepository",
          "ecr:PutLifecyclePolicy",
          "ecr:GetLifecyclePolicy",
          "ecr:DeleteLifecyclePolicy",
          "ecr:ListTagsForResource",
          "ecr:TagResource",
          "ecr:UntagResource"
        ]
        Resource = "arn:aws:ecr:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:repository/${var.project_name}-*"
      },
      # ECS - scoped to project resources
      {
        Effect = "Allow"
        Action = [
          "ecs:CreateCluster",
          "ecs:DeleteCluster",
          "ecs:DescribeClusters",
          "ecs:ListClusters",
          "ecs:UpdateClusterSettings",
          "ecs:PutClusterCapacityProviders",
          "ecs:CreateService",
          "ecs:UpdateService",
          "ecs:DeleteService",
          "ecs:DescribeServices",
          "ecs:ListServices",
          "ecs:RegisterTaskDefinition",
          "ecs:DeregisterTaskDefinition",
          "ecs:DescribeTaskDefinition",
          "ecs:ListTaskDefinitions",
          "ecs:DescribeTasks",
          "ecs:ListTasks",
          "ecs:TagResource",
          "ecs:UntagResource",
          "ecs:ListTagsForResource"
        ]
        Resource = "*"
        Condition = {
          StringLike = {
            "aws:ResourceTag/Project" = var.project_name
          }
        }
      },
      # ECS - allow operations on project-prefixed resources
      {
        Effect = "Allow"
        Action = [
          "ecs:CreateCluster",
          "ecs:DeleteCluster",
          "ecs:DescribeClusters",
          "ecs:UpdateClusterSettings",
          "ecs:CreateService",
          "ecs:UpdateService",
          "ecs:DeleteService",
          "ecs:DescribeServices",
          "ecs:RegisterTaskDefinition",
          "ecs:DeregisterTaskDefinition",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeTasks",
          "ecs:TagResource"
        ]
        Resource = [
          "arn:aws:ecs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:cluster/${var.project_name}-*",
          "arn:aws:ecs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:service/${var.project_name}-*/*",
          "arn:aws:ecs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:task-definition/${var.project_name}-*:*"
        ]
      },
      # ECS - list operations need broader access
      {
        Effect = "Allow"
        Action = [
          "ecs:ListClusters",
          "ecs:ListServices",
          "ecs:ListTaskDefinitions",
          "ecs:ListTasks",
          "ecs:DescribeTaskDefinition"
        ]
        Resource = "*"
      },
      # IAM - scoped to project roles only
      {
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:UpdateRole",
          "iam:UpdateAssumeRolePolicy",
          "iam:PassRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:GetRolePolicy",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:ListInstanceProfilesForRole"
        ]
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.project_name}-*"
      },
      # IAM OIDC Provider - for reading GitHub OIDC provider
      {
        Effect = "Allow"
        Action = [
          "iam:ListOpenIDConnectProviders",
          "iam:GetOpenIDConnectProvider"
        ]
        Resource = "*"
      },
      # Terraform state
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-terraform-state-${data.aws_caller_identity.current.account_id}",
          "arn:aws:s3:::${var.project_name}-terraform-state-${data.aws_caller_identity.current.account_id}/*"
        ]
      },
      # VPC, Networking, Load Balancing (broad for now, can scope later)
      {
        Effect = "Allow"
        Action = [
          "ec2:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:*"
        ]
        Resource = "*"
      },
      # RDS - scoped to project resources
      {
        Effect = "Allow"
        Action = [
          "rds:*"
        ]
        Resource = [
          "arn:aws:rds:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:cluster:${var.project_name}-*",
          "arn:aws:rds:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:db:${var.project_name}-*",
          "arn:aws:rds:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:cluster-pg:*",
          "arn:aws:rds:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:subgrp:${var.project_name}-*"
        ]
      },
      # RDS - describe operations need broader access
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBClusters",
          "rds:DescribeDBInstances",
          "rds:DescribeDBSubnetGroups",
          "rds:DescribeDBClusterParameterGroups",
          "rds:DescribeDBClusterParameters",
          "rds:DescribeGlobalClusters",
          "rds:CreateDBCluster",
          "rds:CreateDBSubnetGroup",
          "rds:CreateDBClusterParameterGroup"
        ]
        Resource = "*"
      },
      # Secrets Manager - scoped to project
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:*"
        ]
        Resource = "arn:aws:secretsmanager:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:secret:${var.project_name}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:ListSecrets",
          "secretsmanager:GetRandomPassword"
        ]
        Resource = "*"
      },
      # CloudWatch Logs - scoped to project
      {
        Effect = "Allow"
        Action = [
          "logs:*"
        ]
        Resource = [
          "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:/ecs/${var.project_name}-*",
          "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:/ecs/${var.project_name}-*:*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:CreateLogGroup"
        ]
        Resource = "*"
      },
      # CloudWatch Alarms & SNS for monitoring
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:ListTagsForResource",
          "cloudwatch:TagResource",
          "cloudwatch:UntagResource"
        ]
        Resource = "arn:aws:cloudwatch:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:alarm:${var.project_name}-*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:CreateTopic"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:DeleteTopic",
          "sns:GetTopicAttributes",
          "sns:SetTopicAttributes",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sns:ListTagsForResource",
          "sns:TagResource",
          "sns:UntagResource",
          "sns:ListSubscriptionsByTopic"
        ]
        Resource = "arn:aws:sns:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:${var.project_name}-*"
      },
      # ACM, Route53, KMS (needed for SSL certs and DNS)
      {
        Effect = "Allow"
        Action = [
          "acm:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:*",
          "route53domains:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:CreateKey",
          "kms:DescribeKey",
          "kms:GetKeyPolicy",
          "kms:ListAliases",
          "kms:CreateGrant",
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      },
      # AWS Budgets
      {
        Effect = "Allow"
        Action = [
          "budgets:ViewBudget",
          "budgets:ModifyBudget",
          "budgets:CreateBudgetAction",
          "budgets:DeleteBudgetAction",
          "budgets:UpdateBudgetAction",
          "budgets:ListTagsForResource",
          "budgets:TagResource",
          "budgets:UntagResource"
        ]
        Resource = "arn:aws:budgets::${data.aws_caller_identity.current.account_id}:budget/${var.project_name}-*"
      }
    ]
  })
}
