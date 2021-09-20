# Implementation of a CI/CD infrastructure

## Technological prerequisites:

![Technology](/images_infra/iconos_tecnogia.png)

* Cloud computing provider. **AWS.**
* Open source operating systems. **Linux, Ubuntu server.**
* Version control. **Git**
* Code repository. **Github.**
* Continuous integration automation. **Jenkins.**
* Automation of configuration and provisioning. **Ansible.**
* Image builder. **Packer.**
* Infrastructure management as code. **Terraform.**
* Knowledge in; **shell script, json encode, php, html, Devops concept.**

![CI/CI Pipeline](/images_infra/infras_cicd.png)

## Description of the infrastructure

* AWS Region (us-east-1). Northern Virginia is the region where our infrastructure is located.
* VPC of production segment 10.0.0.0/16. It is the segment where the production services are hosted.
* Route53 - timevaluerd.com. A domain was created to have a more friendly dns and to be able to direct the traffic from the internet to our infrastructure.
* Availability zone 1 and 2. We have 2 zones or data centers for high availability.
* Public Subnet. It is the subnet where the instances that provide services to the production are located
* Auto Scaling group. It allows us to have an auto scaling of resources in the face of high application demand, starting with 2 until reaching 4. The automatic refreshing is also configured before an image change.
* Elastic Load Balancing. It allows load balancing between both instances located in different Availability Zones.
* EC2 app Instance. They are instances created from the image that the application contains.
* Internet gateway. It allows the VPC to have communication with the outside world.
* AMI. The image repository appears in aws.
* Developer VPC 172.30.0.0/16. Segment that is hosting the non-productive services.
* Availability zone 3. Availability zone where the non-production instances are located.
* Private Subnet. Private sub network where the non-productive services are located.
* Jenkins - EC2. It is the instance where the Jenkins automation tool is installed.
* QA - EC2 - test. It is the instance that runs when it is necessary to test the application.
* Elastic ip Address. Ip publishes static assigned to the Jenkins instance so github can communicate.

## Project description.

### The project contains 4 important folders.

![Directories](/images_infra/directories.png)

#### 1- jenkins_install: contains the terraform code to build the jenkins instance, ansible for the configuration of all dependencies, some scripts and the Jenkins file that we will execute in the pipeline.

Subfolders and their content:

* **ansible_jenkins.** Ansible's playbook to configure and install dependencies on the server.
* **script.** Start, stop and terminate Jenkins instance from shell script by command line.
* **terraform_jenkins.** Terraform code to create the jenkins instance.
* **Jenkinsfile.** The steps to execute the pipeline are defined.

#### 2- QA_EC2_code: Contains the terraform code to create the QA instance to test the new code, and the “app_test.sh” script used by jenkins to call the terraform code.

Subfolders and their content:

* **QA_ec2.** Moludo to create the ec2 instance, and the app_deploy.sh script to deploy the application after the instance is up.
* **QA_sg.** Module to create the security group.
* **app_test.sh,** script called from jenkins to create QA test instance.

#### 3- packer_img. It contains the files necessary to provision the server and create the image with the new version of the code.

Subfolders and their content:

* **ansible_code.** Contains the playbook to configure, install and deploy the application in the instance where the image will be built.
* **terraform_test_ansible_code.** Terraform code that creates an instance to test the ansible playbook.
* **app_build.sh,** Sell script that calls packer to build the image.
* **last_image.log,** ami identifier in aws of the last image created with packer.
* **packer_image.json,** code in json format that allows packer to build the image.
* **previous_image.log,** ami identifier in aws of the previous image created by packer.

#### 4- Infra_pro_terraform: Contains the terraform code to mount the infrastructure and a shell script used by the pipeline in Jenkins.

Subfolders and their content:

* **auto_sg_pro.** Module to create the auto scaling group and policy resources.
* **ec2_pro.** Module to create load balancing resources and ec2 instances.
* **script.** It contains a script to stop an instance from the console "stop_instance.sh" and a script to run a stress test on an instance "run_cpu_stress.sh".
* **sg_pro.** Module to create the security groups of the ec2 and load balance instances.
* **vpc_modules.** Module that allows you to create the production vpc.
* **infra_build.sh,** script called from Jenkins to build the infrastructure in production.



# Implementation detail.

Jenkins is the main implementation where processes are stored and run. It is responsible for receiving the events from github and proceeding with the execution of the pipeline to perform the unit tests, the construction of the image and the deployment in production.

To get Jenkins up and running we need the following prerequisites.

1- A computer where the code is downloaded from the repository, must have the following tools installed; git, ansible, terraform, aws cli, and packer.

2- You must have an account registered in aws with administrator permissions, and a type rsa key pair. The account will be configured in aws cli and the key will be used in all the instances that we will be working on.

## Implementation of the Jenkins instance in AWS.

1. We download the code from the repository on github.

```sh
git clone https://github.com/augustominaya/augustominaya-devops_test.git devops_test
```
2. We must change some variables inside the ec2_jenkins_main.tf file located in the path devops_test / jenkins_install / terraform_jenkins / ec2_jenkins /
```sh
vi devops_test/jenkins_install/terraform_jenkins/ec2_jenkins/ec2_jenkins_main.tf
```
### Mandatory variables

* Subnetid = “Subnet id on the vpc you want to use”
* aws_key = “rsa_key”

### Optional variables

* Nameserver = “Server name”
* instancetype = “Instance type”

3. The terraform code for Jenkins makes use of the jenkins_SG module, to create the security group and the ec2_Jenkins module, to create the instance and the elastic ip.

4. We move to the devops_test directory and execute terraform init, then a terraform plan and finally a terraform apply
```sh
cd devops_test/ && teraform init
```
```sh
terraform plan && teraform apply
```
5. After terraform completes the creation of the Jenkins instance, in the output it will show us the public IP address to connect our instance. Then this IP will be configured in the inventory that ansible will use to connect to configure the server.

## Server configuration with ansible.

1. We move to the devops_test/ path, and create the aws_ssh_key folder.
```sh
mkdir aws_ssh_key
```
2. We copy the rsa key in .pem format that we have downloaded from aws to our machine. If the key is in the download directory, copy it with the following command.
```sh
cp ~/Downloads/*.pem aws_ssh_key
```
3. We open the inventory file and configure 2 variables, ansible_host and ansible_ssh_private_key_file.
```sh
vi jenkins_install/ansible_jenkins/inventory
```
4. Let's access the jenkins_install / ansible_jenkins / directory and run our playbook install_jenkins.yml
```sh
cd jenkins_install/ansible_jenkins/ && sudo ansible-playbook -i inventory install_jenkins.yml
```


![CI/CI Pipeline](/images_infra/cicdpipeline.png)

## Explanation of the CI/CD process

1. The developer Augusto makes a commit and then a push to the github repository.
2. the push causes Github to generate a webhook event to call Jenkins.
3. Jenkins activates a pipeline task with 3 steps.
4. Step one "Unit test" = **"Test_QA_EC2"**, execute a script that calls terraform to create an EC2 where the new version of the application is deploy and later a navigation test is executed.
5. Step two "Build Phase" = **"Build_packer_image"**, run a script that calls packer to build an image including the new version of the application and its dependencies.
6. Step three "Production" = **"Deploy_Infra_Pro"**, execute a script that calls terraform to deploy the image created with packer that contains the new version of the code.

![Jenkins Pipeline](/images_infra/pipeline.png)

![Pipeline](/images_infra/pipelinestep1.png)

### Jenkins Pipeline Step 1 - Test_QA_EC2

* **Image in packer.** The cycle is started by verifying if the file named “last_image.log” exists in the operating system. If it is positive, the id of the image found inside the file is read and exported to an environment variable, otherwise the test is unsuccessful.**Test failed**
* **Terraform Apply.** Through an environment variable, we pass terraform the id of the image to use, and launch the terraform apply command.
* **Terraform error.** If the instance is created correctly we continue the process, otherwise the test is unsuccessful. **Test failed**
* **Get instance IP.** With the terraform output command we retrieve the public ip of the instance,
* **Instance ip ok ?** If the IP is recovered we continue the process, otherwise the test is unsuccessful. **Test failed**
* **App http request.** Using the curl command we make an http request to the previously recovered public ip.
* **Get response code.** We retrieve the http response code.
* **Response code ok ?** If the http code is satisfactory we give the test completed, otherwise it is unsuccessful. **Test failed**
* **Terraform destroy.** The test completes successfully, we terminate the instance with terraform destroy.
* **Test complete.** The application test is completed successfully. 
* **End.**

![Jenkins Pipeline](/images_infra/pipelinestep22.png)

### Jenkins Pipeline Step 2 - Build_packer_image

* **Logs directory exists ?** It is verified that the logs directory exists, otherwise it is created and the process continues.
* **packer validate.** Process that validates the configuration file in json format.
* **config file ok ?** If the configuration file is validated, the process continues, otherwise the process is unsuccessful.
* **Setting enviroment variable.** 4 environment variables are configured before building the image.
* **Packer build.** The packer build command is executed to start the image build process.
* **Build ok ?** If the construction is completed satisfactorily, we continue the process, otherwise the process is unsuccessful.
* **Save the last image id to a file.** The id of the previous image is saved in a file.
* **Save the new image id to a file.** The id of the image generated by packer during construction is saved in a file.
* **Build complete.** Construction is completed.
* **End.**

![Pipeline step 3 Deploy_Infra_Pro](/images_infra/pipelinestep3.png)

### Jenkins Pipeline Step 3 - Deploy_Infra_Pro

* **image in packer ?** If there is an image created by packer, the process continues, otherwise the deployment is unsuccessful.
* **Terraform apply.** We proceed with the deployment of the infrastructure.
* **Terraform error.** If there are no errors it continues, otherwise the deployment is unsuccessful.
* **Verify instance.** It is verified that the instances start with the new image.
* **New image ok ?** If the new image is deployed in the instances, the deployment is complete, otherwise it is re-verified.
* **Deploy complete.** Deployment completed.
* **End.**
