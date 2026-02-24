variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

# 0..N subnets publics : si vide => aucun public subnet
variable "public_subnets" {
  description = "Map: name => { cidr, az }"
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {}
}

# 1..N subnets privés (tu peux mettre 1, 2, 10...)
variable "private_subnets" {
  description = "Map: name => { cidr, az }"
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {}
}
