data "aws_vpc" "vpc" {
  default = true
}

variable "cluster_name" {
}
variable "HostIp" {
}

output "ELBSG1" {
        value = aws_security_group.ELB-SG1
}

# ELB Security Group
resource "aws_security_group" "ELB-SG1" {
  name                       = "${var.cluster_name}-ELB-SG"
  description                = "Allow all - traffic"
  vpc_id                     = data.aws_vpc.vpc.id
  ingress {
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    cidr_blocks              = ["0.0.0.0/0"]
  }
  egress {
    from_port                = 0
    to_port                  = 0
    protocol                 = "-1"
    cidr_blocks              = ["0.0.0.0/0"]
  }
  lifecycle {

    create_before_destroy = true
  }
}

output "webSG2" {
        value = aws_security_group.web-SG2
}

# Webserver Instance Security Group
resource "aws_security_group" "web-SG2" {
        name        = "webserver SG"
        description = "webserver Security Group"
        vpc_id      = data.aws_vpc.vpc.id
        ingress {
                from_port   = 22
                to_port     = 22
                protocol    = "tcp"
                cidr_blocks = [ "0.0.0.0/0" ]
        }
        ingress {
                from_port   = 80
                to_port     = 80
                protocol    = "tcp"
                cidr_blocks = [ "0.0.0.0/0" ]
        }

        ingress {
                from_port   = 80
                to_port     = 80
                protocol    = "tcp"
                cidr_blocks = ["${var.HostIp}"]
        }
        ingress {
                from_port       = 80
                to_port         = 80
                protocol        = "tcp"
                security_groups = ["${aws_security_group.ELB-SG1.id}"]
        }
        egress {
                from_port   = 0
                to_port     = 0
                protocol    = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
  lifecycle {
    create_before_destroy = true
  }
}