#!/bin/bash
# Fecha 2021-09-17
# Creado por: Augusto MInaya
# Script to stress the cpu of one instance
# Stress CPU of the CPU to provoque new instance create whit autoscaling group

echo "#############################"
echo "#  Script to stress cpu  #"
echo "#############################"


echo "#-----> STEP_01 <-----#"
echo "#-----> View the instance ID to be stop"
sleep 1
export Public_ip=`aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values='*cluster*'" |grep PublicIpAddress |head -1 |cut -d ":" -f 2 |sed -e "s/ //g;s/\",//g;s/\"//g"`
echo "#-----> Public ip of the instance to stress: $Public_ip"

echo "#-----> STEP_02 <-----#"
echo "#-----> Run stress script"
sleep 1
ssh -i ../../aws_ssh_key/Terraform_key.pem ubuntu@$Public_ip "echo 'while true; do date; done' > /tmp/cpu.sh && chmod +x /tmp/cpu.sh && nohup /tmp/cpu.sh 1>/dev/null & exit"

if [ $? -ne '0' ]
then  
echo "-----> AWS CLI Error, please look at the screen to identify the error"
exit 1
else
echo "#############################"
echo "#  Stress CPU successfully  #"
echo "#############################"
fi