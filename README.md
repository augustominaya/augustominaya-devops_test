# Implementation of a CI/CD infrastructure

## Technological prerequisites:

![Technology](/images_infra/iconos_tecnogia.png)

* Cloud computing provider. **AWS.**
* Open source operating systems. **Linux, Ubuntu server.**
* Version control. **Git**
* Code repository. **Github.**
* Continuous integration automation. **Jenkins.**
* Automation of configuration and provisioning. **Ansible.**
* Construction of imagener and templates. **Packer.**
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
* To my. The image repository appears in aws.
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

![CI/CI Pipeline](/images_infra/cicdpipeline.png)

## Explanation of the CI/CD process

1. The developer Augusto makes a commit and then a push to the github repository.
2. the push causes Github to generate a webhook event to call Jenkins.
3. Jenkins activates a pipeline task with 3 steps.
4. Step one, execute a script that calls terraform to create an EC2 where the new version of the application is displayed and later a navigation test is executed.
5. Step two, run a script that calls packer to build an image including the new version of the application and its dependencies.
6. Step three, execute a script that calls terraform to deploy the image created with packer that contains the new version of the code.
