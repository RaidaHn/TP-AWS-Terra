variable "private_subnet_ids" {
  description = "Map of private subnet ids"
  type        = map(string)
}

variable "sg_web_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_id" {
  description = "AMI to use for EC2"
  type        = string
}

variable "name_prefix" {
  type    = string
  default = "lab"
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}