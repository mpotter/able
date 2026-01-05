# Aurora Serverless v2 PostgreSQL

# Security group for Aurora
resource "aws_security_group" "aurora" {
  name        = "${var.project_name}-${var.environment}-aurora-sg"
  description = "Security group for Aurora Serverless"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from ECS"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-aurora-sg"
  }
}

# Subnet group for Aurora
resource "aws_db_subnet_group" "aurora" {
  name       = "${var.project_name}-${var.environment}-aurora-subnet"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.project_name}-${var.environment}-aurora-subnet"
  }
}

# Aurora Cluster
resource "aws_rds_cluster" "main" {
  cluster_identifier = "${var.project_name}-${var.environment}"
  engine             = "aurora-postgresql"
  engine_mode        = "provisioned"
  engine_version     = "16.4"
  database_name      = "able"

  master_username                     = var.db_master_username
  manage_master_user_password         = true # AWS manages password in Secrets Manager

  db_subnet_group_name   = aws_db_subnet_group.aurora.name
  vpc_security_group_ids = [aws_security_group.aurora.id]

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 4
  }

  skip_final_snapshot = var.environment != "prod"

  backup_retention_period = var.environment == "prod" ? 7 : 1

  tags = {
    Name = "${var.project_name}-${var.environment}-aurora"
  }
}

# Aurora Instance (Serverless v2)
resource "aws_rds_cluster_instance" "main" {
  identifier         = "${var.project_name}-${var.environment}-1"
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version

  tags = {
    Name = "${var.project_name}-${var.environment}-aurora-instance"
  }
}

# Output the database connection info
output "database_endpoint" {
  value       = aws_rds_cluster.main.endpoint
  description = "Aurora cluster endpoint"
}

output "database_secret_arn" {
  value       = aws_rds_cluster.main.master_user_secret[0].secret_arn
  description = "ARN of the secret containing database credentials"
}
