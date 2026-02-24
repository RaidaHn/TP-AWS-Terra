variable "public_subnet_id" {
  description = "Subnet public où placer la NAT Gateway"
  type        = string
}

variable "nat_name" {
  type    = string
  default = "nat-gateway"
}