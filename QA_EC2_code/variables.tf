variable "last_ami" {
  description = "AMI ID to be used for Instance "
  type        = string
  default = "Not_IMAGE"
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
  default     = "QA_test"
}