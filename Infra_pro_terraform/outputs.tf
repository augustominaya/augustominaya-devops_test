# Nginx WebServer DNS NAME

output "webserver_elb_dns" {
  description = "Web Service DNS NAME"
  value = [module.ec2_pro.load_balance_conf.dns_name]
}
output "webserver_elb_id" {
  description = "Web Service ID"
  value = [module.ec2_pro.load_balance_conf.id]
}

# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}
#CIDR
output "cidr" {
  description = "The CIDR block range of the VPC"
  value  = "${module.vpc.vpc_cidr_block}"
}
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnets}"]
}
# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.vpc.nat_public_ips}"]
}
