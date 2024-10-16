output "instance_private_ips" {
  description = "Private IP of Instances"
  value       = aws_instance.instance.*.private_ip
}

output "instance_ids" {
  description = "List of Instance IDs"
  value       = aws_instance.instance.*.id
}
