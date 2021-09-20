# Implementation of a CI/CD infrastructure


![CI/CI Pipeline](https://devopstestacmc.s3.us-east-1.amazonaws.com/cicdpipeline.png?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEG8aCXVzLWVhc3QtMSJHMEUCIQC7AI7yRhLMHVty5kfqAMzXrsIsg0YG11QFLwGtBoy1swIgdJp26xglEVjnifsmWSiG80rSofzPF%2FNgI5kba7clZUIqlgMIyP%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARACGgw3Mzc0MjM5NzczMDkiDIOoE1mqrvk%2FF6gC1SrqAjmX7Vj%2BsQlVRHVRoeq68uA%2FWuOTE%2FPjRkVf1qU52e%2BX2A2srQEJbFrx3pzC%2B7Qinnphz0EkewW%2F8BUtA1zgYhouNnd9wiWUoc9r97DU3a7cL1fWXzDeHxWAiCxVWpwEymwOQVdw2m04HcvrarYO6so49qpb1aCGkT5xd0BP9DxuEZY7JHVQcZhjjcSOQShQo5EQ%2FahqJjiKJ62Xu4ruVf9p%2BZclMsdXPZuL4N%2BJNvwuGkd80gKcq0HGAOFLdGY%2F2XFkTEsoMFsnXgeXe5gxG9O2CoqRj03NHS5lkv3V0dKoSdC2Rn58wY1%2Bc8mjZoIOSZKUojBHfsHvqcum653TmpQny%2Btm63wz6eNTHeZX%2BOJxMgEnbUPcArHWbfiaABLGkupN0%2FDy4xa8mW0L%2BANroHaVyJKUMWPx6mwHqoCcosiKzUSie7xrSz69%2B2WnnR8RLvhjLxkNstetEpG3XpUSHGaGQmaAHAJIo%2FPjMOPAnIoGOrMCpjc6JkHF%2FynFWKiK1qOk1yPVatvVXWZnCS6Cpfb5y6wD1O9gCGqrdT5l9eNHbFi3mb26QGRhlqs17lZa4%2BJjX7%2Fesf2W1LTWU0MfgZf8fLH6S70dT%2Bnvegi0QGC5QEIT%2BUu5%2F8w0G8hvgvr5Zqvdx7JjXYwwP0E9%2BHG5VJKazhAWp5bS6rhxuC2dEBHPP9xQx3ksys7u43Vu%2BeLSMrMx4750RQPS%2B5mniOkQaB4ethwOyOz7tzv9ojXpL4pE6ThCHSkfFusBo3Y7smfP5f0nAV2bWtGG6jTVUSvsHB%2BlZzRLWSBHRB%2FIg02MIL6U6A8y%2B0hosOavAh3F8QTK3E3lT2E2yshdIralRuddIhsfwlOXjgcHRti5VIBpn%2B02mImysyvbPh5rjRY90tVCJQpoq%2B37Kg%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20210919T231933Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIA2XMPE5NO6B53A6CT%2F20210919%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=3748283cf2ff5beb2ceab520a87aca261732d7ed37ee29bbfbb7df9d35a96908)

## Explanation of the CICD process

1. The developer Augusto makes a commit and then a push to the github repository.
2. the push causes Github to generate a webhook event to call Jenkins.
3. Jenkins activates a pipeline task with 3 steps.
4. Step one, execute a script that calls terraform to create an EC2 where the new version of the application is displayed and later a navigation test is executed.
5. Step two, run a script that calls packer to build an image including the new version of the application and its dependencies.
6. Step three, execute a script that calls terraform to deploy the image created with packer that contains the new version of the code.
