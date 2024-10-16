output "instance_private_ips" {
  description = "Private IP of Instances"
  value       = aws_instance.instance.*.private_ip
}

output "instance_ids" {
  description = "List of Instance IDs"
  value       = aws_instance.instance.*.id
}

output "loadbalancer_dns_name" {
  description = "URL of LoadBalancer"
  value       = module.elb.elb_dns_name
}
