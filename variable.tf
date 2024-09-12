variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}
variable "access_key" {
  type = string
  
}
variable "secret_key" {
  type = string
  
}
variable "cluster_name" {
  type = object({
      cluster_name = string
  })
  
}

variable "task-definition" {
  type = object({
    task_family = string
    task_cpu = number
    task_memory = number 
    container_name = string
    container_port = number
  })
  
}

variable "service" {
  type = object({
    service_name = string
    desired_task_count = number
  })
}

################################

variable "VPC" {
  type = object({
    vpc_cidr_block      = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
    #create_internet_gateway = bool this value used with conditionally created IGW
    create_nat_gateway = bool
    #environment        = string it is use when var.enviroment tag values will be used
  })
}

variable "applb" {
  type = object({
    alb_name = string
    target_group_name = string
    target_group_protocol = string
    health_check_path = string
    health_check_protocol = string
    health_check_interval = number
    health_check_timeout = number
    health_check_healthy_threshold = number
    health_check_unhealthy_threshold = number
  })
  
}
variable "security-group" {
  type = object({
    ecs-sercive-sg           = list(string)
    lbport                   = list(string)
  })
}

# variable "cluster_id" {
#   type = string
# }
# variable "service_name" {
#   type = string
  
# }