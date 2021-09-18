provider "aws"{
    region = "us-east-1"
}


//ec2 module
module "ec2_module"{
    source = "./QA_ec2/"

    ami_id = var.last_ami
    instancetype = var.instancetype
    subnetid = var.subnetid
    aws_key = var.aws_key
    nameserver = var.nameserver
}

//show the public ip of the ansible test ip
output "PublicIP" {
    value = module.ec2_module.pub_ip
}