##################### network ######################
output "vpc_id" {
  description = "vpc_id : "
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

##################### routing-public ######################
output "igw_id" {
  value = module.routing_public.igw_id
}

output "public_route_table_id" {
  value = module.routing_public.public_route_table_id
}

##################### NAT + routing-private ######################
output "nat_gw_id" {
  value = module.nat.nat_gw_id
}

output "private_route_table_id" {
  value = module.routing_private.private_route_table_id
}

##################### Security-groups ######################
output "sg_alb_id" {
  value = module.security_groups.sg_alb_id
}

output "sg_web_id" {
  value = module.security_groups.sg_web_id
}

##################### ALB ######################
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

##################### EC2 ######################
output "web_instance_ids" {
  value = module.compute.instance_ids
}

output "web_private_ips" {
  value = module.compute.private_ips
}