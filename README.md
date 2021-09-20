# Implementation of a CI/CD infrastructure

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
* Availability zone 3. You are in a different availability zone than the production services.
* Private Subnet. Private sub network where the non-productive services are located.
* Jenkins - EC2. It is the instance where the Jenkins automation tool is installed.
* QA - EC2 - test. It is the instance that runs when it is necessary to test the application.
* Elastic ip Address. Ip publishes static assigned to the Jenkins instance so github can communicate.

![CI/CI Pipeline](/images_infra/cicdpipeline.png)

## Explanation of the CI/CD process

1. The developer Augusto makes a commit and then a push to the github repository.
2. the push causes Github to generate a webhook event to call Jenkins.
3. Jenkins activates a pipeline task with 3 steps.
4. Step one, execute a script that calls terraform to create an EC2 where the new version of the application is displayed and later a navigation test is executed.
5. Step two, run a script that calls packer to build an image including the new version of the application and its dependencies.
6. Step three, execute a script that calls terraform to deploy the image created with packer that contains the new version of the code.
