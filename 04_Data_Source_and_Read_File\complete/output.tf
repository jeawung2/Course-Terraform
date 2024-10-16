output "instance_public_ip_a" {
  description = "Public IP of Instance"
  value       = aws_instance.instance_a.public_ip
}

output "instance_public_ip_b" {
  description = "Public IP of Instance"
  value       = aws_instance.instance_b.public_ip
}

output "instance_private_ip_a" {
  description = "Private IP of Instance"
  value       = aws_instance.instance_a.private_ip
}

output "instance_private_ip_b" {
  description = "Private IP of Instance"
  value       = aws_instance.instance_b.private_ip
}

output "instance_elastic_ip_a" {
  description = "Elastic IP of Instance"
  value       = aws_eip.eip_a.public_ip
}

output "instance_elastic_ip_b" {
  description = "Elastic IP of Instance"
  value       = aws_eip.eip_b.public_ip
}
