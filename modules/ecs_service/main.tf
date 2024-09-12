resource "aws_ecs_service" "fargate_service" {
  name            = var.service.service_name
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  launch_type     = "FARGATE"
  desired_count   = var.service.desired_task_count

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups #[aws_security_group.ecs_service_sg.id]
    assign_public_ip = false
  }
  
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.port-container.container_name
    container_port   = var.port-container.container_port
  }
}


