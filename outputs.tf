# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Output declarations
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "lb_url" {
  value       = "httpd://${module.elb_http.elb_dns_name}"
  description = "ELB URL"
}

output "web_server_count" {
  value       = length(module.ec2_instances.instance_ids)
  description = "Number of web servers provisioned"

}
