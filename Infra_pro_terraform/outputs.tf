# Nginx WebServer DNS NAME

output "webserver_elb_dns" {
  description = "Web Service DNS NAME"
  value = [module.ec2_pro.load_balance_conf.dns_name]
}
output "webserver_elb_id" {
  description = "Web Service ID"
  value = [module.ec2_pro.load_balance_conf.id]
}