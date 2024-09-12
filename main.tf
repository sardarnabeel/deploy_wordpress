module "vpc" {
  source  = "./modules/vpc"
  VPC     = var.VPC
}


module "ecs_cluster" {
  source       = "./modules/ecs_cluster"
  cluster_name = var.cluster_name
}

module "ecs_task_definition" {
  source               = "./modules/ecs_task_definition"
  task-definition = var.task-definition
    region               = var.region
}



module "alb" {
  source                      = "./modules/alb"
  applb = var.applb
  alb_security_group_id       = [module.security-group.alb_security_group_id]
  alb_subnet_ids              = [module.vpc.public_subnet_1_id, module.vpc.public_subnet_2_id]
  vpc_id                      = module.vpc.vpc_id
}
module "ecs_service" {
  source              = "./modules/ecs_service"
  cluster_id          = module.ecs_cluster.cluster_id
  task_definition_arn = module.ecs_task_definition.task_definition_arn
  service             = var.service
  subnets             = [module.vpc.private_subnet_id]
  security_groups     = [module.security-group.ecs_service_sg_id]
  target_group_arn    = module.alb.target_group_arn
  port-container      = var.task-definition
  depends_on          = [module.alb.target_group_arn, module.alb.alb_listener_arn]
}

# module "service-autoscaling" {
#   source = "./modules/service-autoscaling"
#   cluster_id = module.ecs_cluster.cluster_id
#   service_name = module.ecs_service.ecs-service-name
# }
module "security-group" {
  source             = "./modules/security-group"
  vpc_id = module.vpc.vpc_id
  security = var.security-group
}

