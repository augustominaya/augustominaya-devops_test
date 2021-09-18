
variable "cluster_name" {
}
variable "HostIp" {
}
variable "ami" {
}
variable "instance_type" {
}
variable "key_name" {
}


#module to define a ec2 and elb security groups
module "sg_pro"{
    source = "../sg_pro"
    cluster_name = "${var.cluster_name}"
    HostIp = "${var.HostIp}"
}

output "webserverconfig" {
        value = aws_launch_configuration.webserver-config
}

# EC2 webserver config launch
resource "aws_launch_configuration" "webserver-config" {
  image_id                  = "${var.ami}"
  instance_type             = "${var.instance_type}"
  key_name                  = "${var.key_name}"
  security_groups           = [module.sg_pro.webSG2.id]
  associate_public_ip_address = "true"
  lifecycle {
    create_before_destroy  = true
  }
}

output "load_balance_conf" {
        value = aws_elb.load-balance-conf
}
#load balance configuration
resource "aws_elb" "load-balance-conf" {
  name = "${var.cluster_name}"
  subnets                     = ["subnet-2eeae963"]
  security_groups             = [module.sg_pro.ELBSG1.id]
  internal                    = false
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  listener {
    instance_port             = "80"
    instance_protocol         = "HTTP"
    lb_port                   = "80"
    lb_protocol               = "HTTP"
  }

  health_check {
    target                    = "TCP:80"
    interval                  = 30
    healthy_threshold         = 2
    unhealthy_threshold       = 2
    timeout                   = 10
  }

  tags = {
   ServerName = "Webserver security-group"
  }
}
