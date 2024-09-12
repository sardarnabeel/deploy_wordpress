# resource "aws_appautoscaling_target" "ecs_service_target" {
#   max_capacity       = 10
#   min_capacity       = 1
#   resource_id        = "service/${var.cluster_id}/${var.service_name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "ecs_service_scaling_policy" {
#   name               = "ecs-service-scaling-policy"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.ecs_service_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_service_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_service_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }
#     scale_in_cooldown  = 60
#     scale_out_cooldown = 60
#     target_value        = 50.0
#   }
# }


#################################
#step scaling policy
##################################
# resource "aws_appautoscaling_target" "ecs_service_target" {
#   max_capacity       = 10
#   min_capacity       = 1
#   resource_id        = "service/${var.cluster_id}/${var.service.service_name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "ecs_service_scaling_policy" {
#   name               = "ecs-service-scaling-policy"
#   policy_type        = "StepScaling"
#   resource_id        = aws_appautoscaling_target.ecs_service_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_service_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_service_target.service_namespace

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 60
#     metric_aggregation_type = "Average"

#     step_adjustment {
#       metric_interval_lower_bound = 0
#       scaling_adjustment          = 1
#     }

#     step_adjustment {
#       metric_interval_upper_bound = 50
#       metric_interval_lower_bound = 0
#       scaling_adjustment          = 1
#     }

#     step_adjustment {
#       metric_interval_upper_bound = 75
#       metric_interval_lower_bound = 50
#       scaling_adjustment          = 2
#     }

#     step_adjustment {
#       metric_interval_upper_bound = 100
#       metric_interval_lower_bound = 75
#       scaling_adjustment          = 3
#     }
#   }
# }