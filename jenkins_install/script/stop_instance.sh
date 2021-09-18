#!/bin/bash
# Fecha 2021-09-17
# Creado por: Augusto MInaya
# Script to Stop jenkins instance

# variables
export jenkins_name='jenkins'

echo "#############################"
echo "#  Script to stop instance  #"
echo "#############################"

echo "#-----> STEP_01 <-----#"
echo "#-----> Get the jenkins instance id"
sleep 1
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values='$jenkins_name'" |grep InstanceId

if [ $? -ne '0' ]
then  
echo "-----> AWS CLI Error getting the ec2 describe-instance, please look at the screen to identify the error"
exit 1
fi

echo "#-----> STEP_02 <-----#"
echo "#-----> View the instance ID to be stop"
sleep 1
export instance_id=`aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values='$jenkins_name'" |grep InstanceId |head -1 |cut -d ":" -f 2 |sed -e "s/ //g;s/\",//g;s/\"//g"`
echo "#-----> Jenkins Instance_id: $instance_id"

echo "#-----> STEP_03 <-----#"
echo "#-----> stop the instance ID: $instance_id"
sleep 1
aws ec2 stop-instances --instance-ids $instance_id

if [ $? -ne '0' ]
then  
echo "-----> AWS CLI Error, please look at the screen to identify the error"
exit 1
else
echo "#######################"
echo "#  Stop successfully  #"
echo "#######################"
fi