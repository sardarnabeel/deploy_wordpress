output "alb_id" {
  value = aws_alb.application_load_balancer.id
}
output "target_group_id" {
  value = aws_lb_target_group.target_group.id
}
output "target_group_arn" {
    value = aws_lb_target_group.target_group.arn
  
}
output "alb_listener_arn" {
  value = aws_lb_listener.listener.arn
}
