variable "name"{
  description = "Name to be used on all resources as prefix"
  default = "webserver"
}

variable "region"{
  default = "us-east-1"
}

variable "tenancy"{
  description = "The tenancy of the instance"
  default = "default"
}

variable "key_name" {
  description = "The key name to use for the instance"
  default = "Terraform_key"
}

variable "instance_count"{
  description = "number of instances to launch"
  default = 1
}

variable "cluster_name" {
  description = "Cluster name to use"
  default = "webserver-cluster"
}

variable "HostIp" {
  description = " Host IP to be allowed SSH for"
  default     = "179.52.233.181/32"
}

variable "last_ami"{
  description = "ID of AMI to use for the instance"
  default = "Not_Image"
}

variable "instance_type"{
  description = "The type of instance to start"
  default = "t2.micro"
}

//variable lista
variable "subnetlist" {
  type = list(string)
  default = ["subnet-fb4d3e9d","subnet-08c2bc29"]
}