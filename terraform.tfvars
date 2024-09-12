region = "us-west-1"

cluster_name = {
  cluster_name = "my-ecs-cluster"
}


task-definition = {
    task_family = "my-task-family"
    task_cpu = 256
    task_memory = 512
    container_name = "my-container"
    container_port = 80
}

service = {
  service_name = "my-ecs-service"
  desired_task_count = 1
}




VPC = {
  vpc_cidr_block      = "10.0.0.0/16"
  public_subnet_cidr  = ["10.0.4.0/24", "10.0.2.0/24"]
  private_subnet_cidr = ["10.0.3.0/24", "10.0.1.0/24"]
  #create_internet_gateway = true this value used with conditionally created IGW
  create_nat_gateway = true
  #environment        = "default" it is used when var.eniroment values will be use
}

applb = {
  alb_name                    = "my-alb"
  target_group_name           = "my-target-group"
  # target_group_port           = 80
  target_group_protocol       = "HTTP"
  health_check_path           = "/"
  health_check_protocol       = "HTTP"
  # health_check_port           = 80
  health_check_interval       = 30
  health_check_timeout        = 5
  health_check_healthy_threshold   = 2
  health_check_unhealthy_threshold = 2
}

security-group = {
  ecs-sercive-sg          = [80, 22, 443]
  lbport                  = [80, 22, 443]
}