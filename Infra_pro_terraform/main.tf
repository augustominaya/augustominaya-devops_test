provider "aws" {
          region = "${var.region}"
       }


# module to define a ec2 and elb security groups
module "ec2_pro"{
    source = "./ec2_pro"
    cluster_name = "${var.cluster_name}"
    ami = "${var.last_ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    HostIp = "${var.HostIp}"
    #subnetlist = "${var.subnetlist}"
    subnetlist = "${module.vpc.public_subnets}"
    vpc_id = "${module.vpc.vpc_id}"
   
}

# module autoscaling_group configuration
module "auto_scaling"{
    source = "./auto_sg_pro"
    web_server_config = module.ec2_pro.webserverconfig
    load_balance_conf = module.ec2_pro.load_balance_conf
    cluster_name = "${var.cluster_name}"
    #subnetlist = "${var.subnetlist}"
    subnetlist = "${module.vpc.public_subnets}"  

}

#module to create a production vpc
module "vpc" {
  source = "./vpc_modules"

  name = "production-vpc"
  cidr = "${var.cidr}"
  azs                 = "${var.azs}"
  public_subnets      = "${var.public_subnets}"

  create_database_subnet_group = false
  enable_nat_gateway = true
  enable_vpn_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "ec2.production"
  dhcp_options_domain_name_servers = "${var.dhcp_options_domain_name_servers}"

  tags = {
    Owner       = "ECS-DEVTEAM"
    Environment = "${var.env}"
  }
}

