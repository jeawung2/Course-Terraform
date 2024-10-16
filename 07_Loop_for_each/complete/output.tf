output "instance_private_ips" {
  description = "Private IP of Instances"
  value       = { for n in keys(var.project) : n => module.ec2[n].instance_private_ips }
  # module.ec2[each.key].instance_private_ips
}

output "instance_ids" {
  description = "List of Instance IDs"
  value       = { for n in keys(var.project) : n => module.ec2[n].instance_ids }
  # module.ec2[each.key].instance_ids
}

output "loadbalancer_dns_name" {
  description = "URL of LoadBalancer"
  value       = { for n in keys(var.project) : n => module.elb[n].elb_dns_name }
  # module.elb[each.key].elb_dns_name
}
