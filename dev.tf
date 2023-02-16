variable "inst_region" {
  type = string
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"

}

variable "vpc_name" {
  type = string
}

variable "profile" {
  type = string
}