
variable "ami_id" {
}
variable "instancetype" {
}
variable "subnetid" {
}
variable "aws_key" {
}
variable "nameserver" {
}
resource "aws_instance" "QA_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instancetype
  key_name               = var.aws_key
  subnet_id              = var.subnetid
  #user_data                 = "${file("app_deploy.sh")}"
  # wait 30 second to the app_deply script finished
  #   provisioner "local-exec" {
  #   command = "sleep 30"
  # }

  vpc_security_group_ids = [module.sg_module.sg_name]

      provisioner "file" {
    source      = "./QA_ec2/app_deploy.sh"
    destination = "/tmp/app_deploy.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/app_deploy.sh",
      "/tmp/app_deploy.sh",
    ]
  }

      connection {
		type        = "ssh"
		user        = "ubuntu"
    private_key = "${file("./aws_ssh_key/Terraform_key.pem")}"
		host        = "${aws_instance.QA_ec2.public_ip}"
	}
  
  tags = {
   Name = "${var.nameserver}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

//security group module
module "sg_module"{
    source = "../QA_sg"
}
//elastic ip to assing to the webserver
# resource "aws_eip" "QA_eip" {
#     instance = aws_instance.QA_ec2.id
# }
# output "pub_ip" {
#     value = aws_eip.QA_eip.public_ip
# }

output "pub_ip" {
    value = aws_instance.QA_ec2.public_ip
}