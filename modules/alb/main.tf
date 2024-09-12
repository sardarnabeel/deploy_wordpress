# source link https://medium.com/@shelley.martinez_40607/create-an-aws-ecs-cluster-using-terraform-91a66732ab05 
#########################################################
# Application Load Balancers
resource "aws_alb" "application_load_balancer" {
  name               = var.applb.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.alb_subnet_ids
  security_groups    = var.alb_security_group_id
}

# Load Balancer Target Group for containers
resource "aws_lb_target_group" "target_group" {
  name        = "container-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = var.applb.health_check_path
    protocol            = var.applb.health_check_protocol
    port                = 80
    # port                = "traffic-port" #var.health_check_port
    interval            = var.applb.health_check_interval
    timeout             = var.applb.health_check_timeout
    healthy_threshold   = var.applb.health_check_healthy_threshold
    unhealthy_threshold = var.applb.health_check_unhealthy_threshold
    matcher             = 200
  }
}

# Load Balancer listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id 
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

