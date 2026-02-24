variable "vpc_name" {
  type    = string
  default = "main-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

# 0..N publics
variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {
    "public-a" = { cidr = "10.10.1.0/24", az = "us-east-1a" }
    "public-b" = { cidr = "10.10.2.0/24", az = "us-east-1b"}
  }
}

# N privés
variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {
    "private-a" = { cidr = "10.10.3.0/24", az = "us-east-1a" }
    # Ajoute autant que tu veux :
    "private-b" = { cidr = "10.10.4.0/24", az = "us-east-1b" }
  }
}

variable "environment" {
  type        = string
  description = "Environment name (dev, val, prod)"
}

variable "client" {
  type        = string
  description = "Client name"
}