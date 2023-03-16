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
  ttl     = "60"

  records = [
    aws_instance.my-ec2-instance.public_ip
  ]
}