output "ecs_service_sg_id" {
  value = aws_security_group.ecs_service_sg.id
}
output "alb_security_group_id" {
    value = aws_security_group.alb_sg.id
  
}