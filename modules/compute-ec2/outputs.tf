output "instance_ids" {
  value = { for k, i in aws_instance.web : k => i.id }
}

output "private_ips" {
  value = { for k, i in aws_instance.web : k => i.private_ip }
}