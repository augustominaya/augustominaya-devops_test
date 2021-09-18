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
}

# module autoscaling_group configuration
module "auto_scaling"{
    source = "./auto_sg_pro"
    web_server_config = module.ec2_pro.webserverconfig
    load_balance_conf = module.ec2_pro.load_balance_conf
    cluster_name = "${var.cluster_name}"

}