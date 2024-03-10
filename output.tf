output "domain_controllers_ip" {
  value = { for instance in aws_instance.domain_controllers : instance.tags.Name => instance.private_ip }
}
output "bastion_host_ip" {
  value = { for instance in aws_instance.bastion_host : instance.tags.Name => instance.private_ip }
}
