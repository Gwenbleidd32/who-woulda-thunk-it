resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app1_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-central-1:430118826493:certificate/1d6792dc-ac01-4a28-9582-440a8e3469ad"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1_tg.arn
  }
}

data "aws_route53_zone" "main" {
  name         = "baldheaddemon.com"
  private_zone = false
}


resource "aws_route53_record" "root" {
  zone_id = "Z099428414507IC8EGW5I"  # Replace with your hosted zone ID
  name    = "baldheaddemon.com"           # Root domain
  type    = "A"

  alias {
    name                   = aws_lb.app1_alb.dns_name  # ALB DNS name
    zone_id                = aws_lb.app1_alb.zone_id   # ALB zone ID
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = "Z099428414507IC8EGW5I"  # Replace with your hosted zone ID
  name    = "www.baldheaddemon.com"       # Subdomain
  type    = "CNAME"
  records = [aws_lb.app1_alb.dns_name]
  ttl     = 300
}
