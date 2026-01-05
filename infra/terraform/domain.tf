# Domain registration nameserver management
# Ensures the registered domain points to our Route53 hosted zone

resource "aws_route53domains_registered_domain" "main" {
  domain_name = var.domain_name

  dynamic "name_server" {
    for_each = aws_route53_zone.main.name_servers
    content {
      name = name_server.value
    }
  }
}
