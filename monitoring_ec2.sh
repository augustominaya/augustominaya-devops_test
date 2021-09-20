#!/bin/bash
# Fecha 2021-09-19
# Creado por: Augusto MInaya
# Script to monitoring instance state

#export last_ami=`cat ../packer_img/previous_image.log`
export last_ami=`cat ../packer_img/last_image.log`

min_instance=2
new_instance_cout=`aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values='*cluster*'"  |grep $last_ami |wc -l`

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