output "sns_topic_arn" {
  description = "ARN of the SNS topic for alarms"
  value       = aws_sns_topic.alarms.arn
}

output "alarm_arns" {
  description = "Map of alarm ARNs"
  value = {
    ecs_cpu_high        = aws_cloudwatch_metric_alarm.ecs_cpu_high.arn
    ecs_memory_high     = aws_cloudwatch_metric_alarm.ecs_memory_high.arn
    ecs_running_tasks   = aws_cloudwatch_metric_alarm.ecs_running_tasks.arn
    alb_5xx_errors      = aws_cloudwatch_metric_alarm.alb_5xx_errors.arn
    alb_target_5xx      = aws_cloudwatch_metric_alarm.alb_target_5xx_errors.arn
    alb_unhealthy_hosts = aws_cloudwatch_metric_alarm.alb_unhealthy_hosts.arn
    rds_cpu_high        = aws_cloudwatch_metric_alarm.rds_cpu_high.arn
    rds_connections     = aws_cloudwatch_metric_alarm.rds_connections_high.arn
    rds_capacity        = aws_cloudwatch_metric_alarm.rds_serverless_capacity.arn
  }
}
