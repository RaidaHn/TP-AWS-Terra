locals {
  common_tags = merge(
    {
      ManagedBy = "terraform"
      Module    = "security-groups"
    },
    var.tags
  )
}

resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-sg-alb"
  description = "ALB security group"
  vpc_id      = var.vpc_id

  # Outbound: allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.name_prefix}-sg-alb" })
}

# Ingress rules for ALB (HTTP/HTTPS) from CIDRs
resource "aws_security_group_rule" "alb_ingress" {
  for_each = { for p in var.alb_ingress_ports : tostring(p) => p }

  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = each.value
  to_port     = each.value
  protocol    = "tcp"
  cidr_blocks = var.alb_ingress_cidrs

  description = "Allow TCP ${each.value} to ALB"
}

resource "aws_security_group" "web" {
  name        = "${var.name_prefix}-sg-web"
  description = "WEB instances security group (only reachable from ALB)"
  vpc_id      = var.vpc_id

  # Outbound: allow all (traffic will go through NAT due to routing)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.name_prefix}-sg-web" })
}

# Allow WEB port from ALB SG
resource "aws_security_group_rule" "web_ingress_from_alb_http" {
  type                     = "ingress"
  security_group_id        = aws_security_group.web.id
  from_port                = var.web_ingress_port
  to_port                  = var.web_ingress_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id

  description = "Allow WEB port from ALB SG"
}

# Optional: allow 443 from ALB to WEB
resource "aws_security_group_rule" "web_ingress_from_alb_https" {
  count = var.enable_web_https_from_alb ? 1 : 0

  type                     = "ingress"
  security_group_id        = aws_security_group.web.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id

  description = "Allow HTTPS from ALB SG"
}