variable "zone_id" {
  type = string
}

variable "domain" {
  type = string
}

resource "aws_route53_record" "example" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }

}
