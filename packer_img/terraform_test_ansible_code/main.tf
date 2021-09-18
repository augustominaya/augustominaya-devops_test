provider "aws"{
    region = "us-east-1"
}

//ec2 module
module "ec2_module"{
    source = "./ansible_test_ec2/"
}

//show the public ip of the ansible test ip
output "PublicIP" {
    value = module.ec2_module.pub_ip
}