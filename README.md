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

#### 1- Infra_pro_terraform: Contains the terraform code to mount the infrastructure and a shell script used by the pipeline in Jenkins.

Subfolders and their content:

* **auto_sg_pro.** Module to create the auto scaling group and policy resources.
* **ec2_pro.** Module to create load balancing resources and ec2 instances.
* **script.** It contains a script to stop an instance from the console "stop_instance.sh" and a script to run a stress test on an instance "run_cpu_stress.sh".
* **sg_pro.** Module to create the security groups of the ec2 and load balance instances.
* **vpc_modules.** Module that allows you to create the production vpc.
* **infra_build.sh,** script called from Jenkins to build the infrastructure in production.

#### 2- QA_EC2_code: Contains the terraform code to create the QA instance to test the new code, and the “app_test.sh” script used by jenkins to call the terraform code.

Subfolders and their content:

* **QA_ec2.** Moludo to create the ec2 instance, and the app_deploy.sh script to deploy the application after the instance is up.
* **QA_sg.** Module to create the security group.
* **app_test.sh,** script called from jenkins to create QA test instance.

#### 3- jenkins_install: contains the terraform code to build the jenkins instance, ansible for the configuration of all dependencies, some scripts and the Jenkins file that we will execute in the pipeline.

Subfolders and their content:

* **ansible_jenkins.** Ansible's playbook to configure and install dependencies on the server.
* **script.** Start, stop and terminate Jenkins instance from shell script by command line.
* **terraform_jenkins.** Terraform code to create the jenkins instance.
* **Jenkinsfile.** The steps to execute the pipeline are defined.

#### 4- packer_img. It contains the files necessary to provision the server and create the image with the new version of the code.

Subfolders and their content:

* **ansible_code.** Contains the playbook to configure, install and deploy the application in the instance where the image will be built.
* **terraform_test_ansible_code.** Terraform code that creates an instance to test the ansible playbook.
* **app_build.sh,** Sell script that calls packer to build the image.
* **last_image.log,** ami identifier in aws of the last image created with packer.
* **packer_image.json,** code in json format that allows packer to build the image.
* **previous_image.log,** ami identifier in aws of the previous image created by packer.

![CI/CI Pipeline](/images_infra/cicdpipeline.png)

## Explanation of the CI/CD process

1. The developer Augusto makes a commit and then a push to the github repository.
2. the push causes Github to generate a webhook event to call Jenkins.
3. Jenkins activates a pipeline task with 3 steps.
4. Step one, execute a script that calls terraform to create an EC2 where the new version of the application is deploy and later a navigation test is executed.
5. Step two, run a script that calls packer to build an image including the new version of the application and its dependencies.
6. Step three, execute a script that calls terraform to deploy the image created with packer that contains the new version of the code.

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
* **End**

![Pipeline step 3 Deploy_Infra_Pro](/images_infra/pipelinestep3.png)
