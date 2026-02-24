locals {
  common_tags = merge(
    {
      ManagedBy = "terraform"
      Module    = "compute-ec2"
    },
    var.tags
  )
}

# 1 instance per private subnet
resource "aws_instance" "web" {
  for_each = var.private_subnet_ids

  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = each.value

  vpc_security_group_ids = [var.sg_web_id]

  user_data = var.user_data

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-web-${each.key}"
  })
}

# Attach instances to ALB target group
resource "aws_lb_target_group_attachment" "web" {
  for_each = aws_instance.web

  target_group_arn = var.target_group_arn
  target_id        = each.value.id
  port             = 80
}