resource "aws_security_group" "this" {
  name_prefix = "${var.name}-alb-"
  description = "Ingress for ${var.name} application load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from approved clients"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_client_cidrs
  }

  egress {
    description = "Application and health-check traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = var.tags
}

resource "aws_lb" "this" {
  name_prefix        = substr("${var.name}-", 0, 6)
  internal           = var.internal
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.this.id]
  subnets            = var.subnet_ids
  idle_timeout       = var.idle_timeout_seconds

  enable_deletion_protection = var.deletion_protection
  drop_invalid_header_fields = true
  tags                       = var.tags
}

resource "aws_lb_target_group" "this" {
  name_prefix = substr("${var.name}-", 0, 6)
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = var.tags
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = var.ssl_policy

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.this.arn
        weight = 100
      }
    }
  }
}
