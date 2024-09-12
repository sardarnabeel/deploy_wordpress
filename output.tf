output "vpc_id" {
  value = module.vpc.vpc_id
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

# output "public_subnet_1_id" {
#   value = module.vpc.public_subnet_ids
# }

output "private_subnet_1_id" {
  value = module.vpc.private_subnet_id
}


output "task_definition_arn" {
  value = module.ecs_task_definition.task_definition_arn
}

output "alb_id" {
  value = module.alb.alb_id
}

output "target_group_id" {
  value = module.alb.target_group_id
}



