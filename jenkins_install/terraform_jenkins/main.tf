provider "aws"{
    region = "us-east-1"
}

//ec2 module
module "ec2_module"{
    source = "./ec2_jenkins/"
}

//show the public ip of the jenkins ip
output "PublicIP" {
    value = module.ec2_module.pub_ip
}