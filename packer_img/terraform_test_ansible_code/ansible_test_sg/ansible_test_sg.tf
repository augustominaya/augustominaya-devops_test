
//return the security group name to assing to the ec2 instance
output "sg_name"{
    value = aws_security_group.ansible_test_traffic.id
}

resource "aws_security_group" "ansible_test_traffic" {
    name = "Allow ANSIBLE TEST"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = [ "0.0.0.0/0" ]
    } 

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}