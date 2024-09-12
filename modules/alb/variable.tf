

variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
}

variable "alb_subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
}


variable "applb" {}