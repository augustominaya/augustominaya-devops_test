#!/bin/bash
# Fecha 2021-09-17
# Creado por: Augusto MInaya
# Script to buil the infraestructure in producction

# function area

Test_failed()
{
sleep 5
terraform destroy -auto-approve
echo "###################################"
echo "# **ERROR** Test failed **ERROR** #"
echo "###################################"
}


echo "###############################"
echo "#  Build the Infraestructure  #"
echo "###############################"

echo "#-----> STEP_01 <-----#"
echo "#-----> Recover the las image generate whit packer"

export last_ami=`cat ../packer_img/last_image.log`
if [[ -z $last_ami ]]
then  
echo "-----> Error export last image generate from packer, check the file: ../packer_img/last_image.log"
exit 1
else
echo "#-----> The last packer image is: $last_ami"
fi

echo "#-----> STEP_02 <-----#"
echo "#-----> Terraform apply"

terraform apply -auto-approve -var "last_ami=${last_ami}"

if [ $? -ne '0' ]
then  
Test_failed
echo "-----> Terraform Error, Please check the logs in the screen"
exit 1
fi

echo "#-----> STEP_03 <-----#"
echo "#-----> check the application of the change of image"

min_instance=2
#new_instance_cout=`aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values='*cluster*'"  |grep $last_ami |wc -l`

 while [ $min_instance -gt 0 ] ;do

new_instance_cout=`aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values='*cluster*'" |grep $last_ami |wc -l`

sleep 1
if [ $new_instance_cout -ge 1 ]
then  

echo "-----> wait, the autoscaling group makeover is not complete yet. instans ok: $new_instance_cout"
let min_instance=$min_instance-1
else
echo "-----> wait, the autoscaling group makeover is not complete yet. instans ok: $new_instance_cout"

fi         
done
echo "-----> Autoscaling group complete change images"

echo "########################################"
echo "#  Deploy Infra complete successfully  #"
echo "########################################"





