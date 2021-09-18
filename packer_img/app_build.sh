#!/bin/bash
# Fecha 2021-09-16
# Creado por: Augusto MInaya
# Script to create build the Aplication image

echo "################################"
echo "#  Build the Aplicacion image  #"
echo "################################"

echo "#-----> STEP_01 <-----#"
echo "#-----> Export variables to loggin the building"

export PACKER_IMG="packer_img"
export nombre_log=packer_log01_$(date +"%F_%H%M%S").txt
export PACKER_LOG=1
export PACKER_LOG_PATH="${PACKER_IMG}/logs/$nombre_log"

echo "#-----> STEP_02 <-----#"
echo "#-----> Packer build image"

packer build ${PACKER_IMG}/packer_image.json

if [ $? -ne '0' ]
then  
echo "-----> Packer Error building image, Please check the logs in the screen"
exit 1
fi

echo "#-----> STEP_03 <-----#"
echo "#-----> Recover AMI id from the executing log: ${PACKER_IMG}/$nombre_log"

export AMI=`cat ${PACKER_IMG}/logs/$nombre_log |grep "amazon-ebs: AMI:" |sed -e "s/ //g" |cut -d ":" -f 6`
if [ -z $AMI ]
then  
echo "-----> AMI image not created, please check the error and try again"
exit 1
fi

echo "#-----> Copy the last_image.log to previous_image.log"
sleep 1
cp -p ${PACKER_IMG}/last_image.log ${PACKER_IMG}/previous_image.log

echo "#-----> Packer image ID: $AMI -> to the last_image.log"
sleep 1
echo $AMI > ${PACKER_IMG}/last_image.log

cat ${PACKER_IMG}/last_image.log |tr -d "[:cntrl:]"  > ${PACKER_IMG}/last_image_tmp.log
cat ${PACKER_IMG}/last_image_tmp.log |cut -d "[" -f 1 > ${PACKER_IMG}/last_image.log
rm ${PACKER_IMG}/last_image_tmp.log

echo "###########################################"
echo "#  Packer Building complete successfully  #"
echo "###########################################"