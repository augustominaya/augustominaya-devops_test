# Implementation of a CI/CD infrastructure

![CI/CI Pipeline](/images_infra/infra_cicd.png)

![CI/CI Pipeline](/images_infra/cicdpipeline.png)

## Explanation of the CI/CD process

1. The developer Augusto makes a commit and then a push to the github repository.
2. the push causes Github to generate a webhook event to call Jenkins.
3. Jenkins activates a pipeline task with 3 steps.
4. Step one, execute a script that calls terraform to create an EC2 where the new version of the application is displayed and later a navigation test is executed.
5. Step two, run a script that calls packer to build an image including the new version of the application and its dependencies.
6. Step three, execute a script that calls terraform to deploy the image created with packer that contains the new version of the code.
