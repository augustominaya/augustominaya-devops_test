#!/bin/bash
# Fecha 2021-09-17
# Creado por: Augusto MInaya
# Script to stop instance

#conect to aws and get the first instance id and stop
#aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values='*cluster*'" |grep InstanceId

echo "#############################"
echo "#  Script to stop instance  #"
echo "#############################"

echo "#-----> STEP_01 <-----#"
echo "#-----> Get the first instance to be stop"
sleep 1
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values='*cluster*'" |grep InstanceId

if [ $? -ne '0' ]
then  
echo "-----> AWS CLI Error getting the ec2 describe-instance, please look at the screen to identify the error"
exit 1
fi

echo "#-----> STEP_02 <-----#"
echo "#-----> View the instance ID to be stop"
sleep 1
export first_ec2=`aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values='*cluster*'" |grep InstanceId |head -1 |cut -d ":" -f 2 |sed -e "s/ //g;s/\",//g;s/\"//g"`
echo "#-----> First EC2: $first_ec2"

echo "#-----> STEP_03 <-----#"
echo "#-----> Stoping the instance ID: $first_ec2"
sleep 1
aws ec2 stop-instances --instance-ids $first_ec2

if [ $? -ne '0' ]
then  
echo "-----> AWS CLI Error, please look at the screen to identify the error"
exit 1
else
echo "#############################"
echo "#  stopped successfully     #"
echo "#############################"
fi