output "ecs_service_id" {
  value = aws_ecs_service.fargate_service.id
}
output "ecs-service-name" {
  value = aws_ecs_service.fargate_service.name
}