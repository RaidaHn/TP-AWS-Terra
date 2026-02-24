output "igw_id" {
  value = local.create_public_routing ? aws_internet_gateway.this[0].id : null
}

output "public_route_table_id" {
  value = local.create_public_routing ? aws_route_table.public[0].id : null
}