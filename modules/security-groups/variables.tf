variable "vpc_id" {
  type = string
}

variable "name_prefix" {
  type    = string
  default = "lab"
}

variable "alb_ingress_cidrs" {
  description = "CIDRs allowed to reach the ALB (HTTP/HTTPS). Example: [\"0.0.0.0/0\"]"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "alb_ingress_ports" {
  description = "Ports open on ALB from alb_ingress_cidrs"
  type        = list(number)
  default     = [80, 443]
}

variable "web_ingress_port" {
  description = "Port exposed by WEB instances from the ALB SG"
  type        = number
  default     = 80
}

variable "enable_web_https_from_alb" {
  description = "If true, also allow 443 from ALB SG to WEB SG"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to security groups"
  type        = map(string)
  default     = {}
}