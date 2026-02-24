variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  description = "Map of public subnet ids (name => subnet-id) coming from module.network.public_subnet_ids"
  type        = map(string)
  default     = {}
}

variable "igw_name" {
  type    = string
  default = "igw"
}

variable "public_rt_name" {
  type    = string
  default = "rt-public"
}