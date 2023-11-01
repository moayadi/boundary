resource "aws_security_group" "lb" {
  count       = var.lb_type == "application" ? 1 : 0
  description = "Security group for the application load balancer"
  name        = "${var.resource_name_prefix}-lb-sg"
  vpc_id      = var.vpc_id

  tags = merge(
    { Name = "${var.resource_name_prefix}-lb-sg" },
    var.common_tags,
  )
}

resource "aws_security_group_rule" "lb_inbound" {
  count             = var.lb_type == "application" && var.allowed_inbound_cidrs != null ? 1 : 0
  description       = "Allow specified CIDRs access to load balancer on port 8200"
  security_group_id = aws_security_group.lb[0].id
  type              = "ingress"
  from_port         = 8200
  to_port           = 8200
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidrs
}

# resource "aws_security_group_rule" "lb_outbound" {
#   count                    = var.lb_type == "application" ? 1 : 0
#   description              = "Allow outbound traffic from load balancer to Vault nodes on port 8200"
#   security_group_id        = aws_security_group.lb[0].id
#   type                     = "egress"
#   from_port                = 8200
#   to_port                  = 8200
#   protocol                 = "tcp"
#   source_security_group_id = var.sg_id
# }

resource "aws_lb" "lb" {
  name                       = "${var.resource_name_prefix}-lb"
  internal                   = false
  load_balancer_type         = var.lb_type
  subnets                    = var.lb_subnets
  security_groups            = [aws_security_group.lb[0].id]
  drop_invalid_header_fields = var.lb_type == "application" ? true : null

  tags = merge(
    { Name = "${var.resource_name_prefix}-lb" },
    var.common_tags,
  )
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.resource_name_prefix}-tg"
  target_type = "instance"
  port        = 8200
  protocol    = "HTTPS"
  vpc_id      = var.vpc_id
  

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout = 2
    protocol            = "HTTPS"
    port                = "traffic-port"
    path                = var.lb_health_check_path
    interval            = 5
    matcher = "200,473"
  }

  tags = merge(
    { Name = "${var.resource_name_prefix}-tg" },
    var.common_tags,
  )
}

resource "aws_lb_listener" "listner" {
  load_balancer_arn = aws_lb.lb.id
  port              = 8200
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.lb_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
