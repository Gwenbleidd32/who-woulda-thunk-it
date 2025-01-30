# ACL
resource "aws_wafv2_web_acl" "poopers" {
  name        = "theos-waf"
  scope       = "REGIONAL" # Use CLOUDFRONT for CloudFront
  description = "Example WAF for theos pleasure"
  default_action {
    allow {}
  }
  rule {
    name     = "IPBlockRule"
    priority = 1
    action {
      block {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_block_list.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "IPBlockRule"
      sampled_requests_enabled   = false
    }
  }
  rule {
    name     = "AWSManagedRulesKnownBadInputs"
    priority = 2
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AWSManagedRulesKnownBadInputs"
      sampled_requests_enabled   = false
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "app1WebACL"
    sampled_requests_enabled   = false
  }
  tags = {
    Name    = "Paul-Atreides"
    Service = "Spice-harvesting"
    Owner   = "Leto-Atreides"
    Planet  = "Arrakis"
  }
}
# IP-BLOCK-LIST
resource "aws_wafv2_ip_set" "ip_block_list" {
  name               = "ip-block-list"
  description        = "List of blocked IP addresses"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
addresses = [
    "1.188.0.0/16",
    "1.80.0.0/16",
    "101.144.0.0/16",
    "101.16.0.0/16"
]
  tags = {
    Name    = "Paul-Atreides"
    Service = "Spice-harvesting"
    Owner   = "Leto-Atreides"
    Planet  = "Arrakis"
  }
}
# Attach the WAF Web ACL to the ALB
resource "aws_wafv2_web_acl_association" "example" {
  resource_arn = aws_lb.app1_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.poopers.arn
}

