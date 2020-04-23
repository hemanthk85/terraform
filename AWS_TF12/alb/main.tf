#----networking/main.tf----

provider "aws" {
  region = "us-east-1"
}

resource "aws_alb_target_group" "tf-target-group" {
  health_check {
    interval		= 10
    path 		= "/"
    protocol		= "HTTP"
    timeout		= 5
    healthy_threshold	= 5
    unhealthy_threshold	= 2
  }

  name                  = "tf-alb-tg"
  port                  = 80
  protocol              = "HTTP"
  target_type		= "instance"
  vpc_id                = var.vpc_id

  tags = {
    Name = "tf-alb-tg"
  }
}

resource "aws_alb_target_group_attachment" "tf-alb-target-group-atatchment-1" {
  target_group_arn	= aws_alb_target_group.tf-target-group.arn
  target_id             = var.instance1_id
  port                  = 80
}

resource "aws_alb_target_group_attachment" "tf-alb-target-group-atatchment-2" {
  target_group_arn      = aws_alb_target_group.tf-target-group.arn
  target_id             = var.instance2_id
  port                  = 80
}

resource "aws_alb" "tf-my-alb" {
  name                  = "tf-test-alb"
  internal 		= false
  subnets               = [var.subnet1, var.subnet2]
  security_groups       = [var.security_group_id]

  tags = {
    Name = "tf-test-alb"
  }
  
  ip_address_type	= "ipv4"
  load_balancer_type	= "application"
}

resource "aws_alb_listener" "tf-test-alb-listener" {
  load_balancer_arn     = aws_alb.tf-my-alb.arn
  port                  = 80
  protocol		= "HTTP"
  
  default_action {
	target_group_arn = aws_alb_target_group.tf-target-group.arn
	type = "forward"
	}
}

resource "aws_security_group" "my-alb-sg" {
  name        = "my-alb-sg"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "inbound_http" {
    from_port   	= 80
    to_port     	= 80
    protocol    	= "tcp"
    security_group_id 	= aws_security_group.my-alb-sg.id
    type 		= "ingress"
    cidr_blocks 	= ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    security_group_id   = aws_security_group.my-alb-sg.id
    type                = "egress"
    cidr_blocks         = ["0.0.0.0/0"]
}
