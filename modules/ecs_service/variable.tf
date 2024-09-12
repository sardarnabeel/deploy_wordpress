variable "cluster_id" {
  description = "ID of the ECS cluster"
  type        = string
}

variable "task_definition_arn" {
  description = "ARN of the task definition"
  type        = string
}

variable "service" {}


variable "subnets" {
  description = "List of subnet IDs for the task"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs for the task"
  type        = list(string)
}

variable "port-container" {}

variable "target_group_arn" {
  type = string
  
}


