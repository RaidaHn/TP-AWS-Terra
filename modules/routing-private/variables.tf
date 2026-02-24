variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  description = "Map of private subnet ids"
  type        = map(string)
}

variable "nat_gw_id" {
  type = string
}

variable "private_rt_name" {
  type    = string
  default = "rt-private"
}