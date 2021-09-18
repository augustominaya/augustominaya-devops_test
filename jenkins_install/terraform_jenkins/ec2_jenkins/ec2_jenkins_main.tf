
variable "ami_id" {
  description = "AMI ID to be used for Instance "
  default     = "ami-09e67e426f25ce0d7"
}
variable "instancetype" {
  description = "Instance Typebe used for Instance "
  #default     = "t2.micro"
  #default     = "m4.large" #recomende by amazon
  default     = "t3.small"
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
  default     = "jenkins"
}
resource "aws_instance" "jenkins_ec2" {
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
    source = "../jenkins_SG"
}
//elastic ip to assing to the webserver
resource "aws_eip" "jenkins_eip" {
    instance = aws_instance.jenkins_ec2.id
}
output "pub_ip" {
    value = aws_eip.jenkins_eip.public_ip
}