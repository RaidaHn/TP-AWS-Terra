# Create resources only if at least one public subnet exists
locals {
  create_public_routing = length(var.public_subnet_ids) > 0
}

resource "aws_internet_gateway" "this" {
  count  = local.create_public_routing ? 1 : 0
  vpc_id = var.vpc_id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "public" {
  count  = local.create_public_routing ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = {
    Name = var.public_rt_name
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.create_public_routing ? var.public_subnet_ids : {}

  subnet_id      = each.value
  route_table_id = aws_route_table.public[0].id
}