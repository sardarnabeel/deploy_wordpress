output "task_definition_arn" {
  value = aws_ecs_task_definition.fargate_task_definition.arn
}