variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  description = "Map of public subnet ids"
  type        = map(string)
}

variable "sg_alb_id" {
  type = string
}

variable "name_prefix" {
  type    = string
  default = "lab"
}

variable "alb_port" {
  type    = number
  default = 80
}

variable "target_port" {
  type    = number
  default = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "tags" {
  type    = map(string)
  default = {}
}