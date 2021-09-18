#!/bin/bash
# Fecha 2021-09-16
# Creado por: Augusto MInaya
# Script to create QA EC2 to test the Aplication

# function area

Test_failed()
{
sleep 5
terraform destroy -auto-approve
echo "###################################"
echo "# **ERROR** Test failed **ERROR** #"
echo "###################################"
}


echo "################################"
echo "#  Deploy and Aplicacion TEST  #"
echo "################################"

echo "#-----> STEP_01 <-----#"
echo "#-----> Terraform apply"

export last_ami=`cat ../packer_img/last_image.log`
if [[ -z $last_ami ]]
then  
echo "-----> Error export last image generate from packer, check the file: ../packer_img/last_image.log"
exit 1
fi

terraform apply -auto-approve -var "last_ami=${last_ami}"
#terraform plan -var "last_ami=${last_ami}"

if [ $? -ne '0' ]
then  
Test_failed
echo "-----> Terraform Error, Please check the logs in the screen"
exit 1
fi

echo "#-----> STEP_02 <-----#"
echo "#-----> Terraform QA EC2 PublicIP Recover"

export PublicIP=`terraform output -raw PublicIP`

if [[ -z $PublicIP ]]
then  
Test_failed
echo "#-----> Variable PublicIP is empty, Not URL to test the aplication"
exit 1
else
echo "#-----> PublicIP = ${PublicIP} " 
fi

echo "#-----> STEP_03 <-----#"
echo "#-----> Acmc home page Testing"

export result_code=`curl -I --stderr /dev/null http://$PublicIP | head -1 | cut -d' ' -f2`

echo "#-----> Response code: $result_code" 

if [[ -z $result_code ]]
then  
Test_failed
echo "#-----> the web server is not responding, response code: |$result_code| is empty"
exit 1
fi

if [ ${result_code} -ne '200' ]
then  
Test_failed
echo "-----> Error testing the aplication in the URL: http://$PublicIP"
echo "-----> Responde code: $result_code"
exit 1
else

echo "#-----> STEP_04 <-----#"
echo "#-----> Terraform destroy | QA EC2 destroy"

terraform destroy -auto-approve

echo "##################################"
echo "#  Testing complete successfully #"
echo "##################################"
echo "-----> The app is deply and Responde code: $result_code in the URL: http://$PublicIP "

fi


