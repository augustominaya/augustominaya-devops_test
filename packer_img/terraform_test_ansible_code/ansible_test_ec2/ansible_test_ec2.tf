
variable "ami_id" {
  description = "AMI ID to be used for Instance "
  #default     = "ami-09e67e426f25ce0d7"
  default     = "ami-09e67e426f25ce0d7"
}
variable "instancetype" {
  description = "Instance Typebe used for Instance "
  default     = "t2.micro"
}
variable "subnetid" {
  description = "Subnet ID to be used for Instance "
  default     = "subnet-2eeae963"
}
variable "aws_key" {
  description = "aws key to connect to the server"
  default     = "Terraform_key"
}
variable "nameserver" {
  description = "Name Server"
  default     = "ansible_test"
}
resource "aws_instance" "ansible_test_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instancetype
  key_name               = var.aws_key
  subnet_id              = var.subnetid
  vpc_security_group_ids = [module.sg_module.sg_name]
  tags = {
   Name = "${var.nameserver}"
  }
  lifecycle {
    create_before_destroy = true
  }
}
//security group module
module "sg_module"{
    source = "../ansible_test_sg"
}
//elastic ip to assing to the webserver
# resource "aws_eip" "ansible_test_eip" {
#     instance = aws_instance.ansible_test_ec2.id
# }
# output "pub_ip" {
#     value = aws_eip.ansible_test_eip.public_ip
# }

output "pub_ip" {
    value = aws_instance.ansible_test_ec2.public_ip
}