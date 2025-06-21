resource "aws_lb" "alb" {
  name               = "particle-dk-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1b.id
  ]
  tags = merge(var.tags, { Name = "particle-dk-alb" })

  depends_on = [
    aws_lb_target_group.tg
  ]
}

resource "aws_lb_target_group" "tg" {
  name     = "particle-dk-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id

  health_check {
    protocol = "HTTP"
    path     = "/"
    matcher  = "200-399"
  }

  tags = merge(var.tags, { Name = "particle-dk-tg" })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
