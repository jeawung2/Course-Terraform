# Lab1. Terraform Cloud Resource 관리

<br>

---
- [Lab1. Terraform Cloud Resource 관리](#lab1-terraform-cloud-resource-관리)
  - [1-1. 실습 목표](#1-1-실습-목표)
  - [1-2. 실습 세부사항](#1-2-실습-세부사항)
    - [1-2-1. `main.tf`](#1-2-1-maintf)
  - [1-3. 실습 결과](#1-3-실습-결과)
    - [1-3-1. `terraform apply`](#1-3-1-terraform-apply)
    - [1-3-2. `terraform state list`](#1-3-2-terraform-state-list)
    - [1-3-3. `terraform destroy`](#1-3-3-terraform-destroy)
---

## 1-1. 실습 목표

- Terraform을 활용하여 AWS EC2 인스턴스 자원을 생성해본다.  
- 생성된 AWS 인스턴스의 이미지를 Ubuntu 20.04에서 Ubuntu 22.04로 변경한다.  
- Terraform Plan/Apply/Destroy Command 출력 결과를 통해 Cloud 자원 변화를 확인한다.  
- 본 실습을 완료하면 아래와 같은 Architecture의 Cloud 자원이 생성된다.

![](../Reference_docs/images/lab/terraform_lab_arhitecture-Lab01.png)
![](/course-terraform/Reference_docs/images/lab/terraform_lab_arhitecture-Lab01.png)

---

## 1-2. 실습 세부사항

### 1-2-1. `main.tf`

- aws_instance 리소스 (EC2 인스턴스)
  - AMI 이미지
    - 초기: Ubuntu 20.04 for ap-northeast-2
      - ami-0d3d9b94632ba1e57
    - 변경: Ubuntu 22.04 for ap-northeast-2
      - ami-09a7535106fbd42d5

---

## 1-3. 실습 결과

### 1-3-1. `terraform apply`

- 최초 실행시 (Ubuntu 20.04 AMI Image)

```bash
mspmanager:~/environment/course-terraform/01_Cloud_Resource/start $ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.instance will be created
  + resource "aws_instance" "instance" {
      + ami                                  = "ami-0d3d9b94632ba1e57"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      ...
      <중략>
      ...
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
aws_instance.instance: Creating...
aws_instance.instance: Still creating... [10s elapsed]
aws_instance.instance: Creation complete after 12s [id=i-0274b99caf324f762]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

- 수정 후 실행시 (Ubuntu 22.04 AMI Image)

```bash
mspmanager:~/environment/course-terraform/01_Cloud_Resource/start $ terraform apply -auto-approve
aws_instance.instance: Refreshing state... [id=i-0274b99caf324f762]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # aws_instance.instance must be replaced
-/+ resource "aws_instance" "instance" {
      ~ ami                                  = "ami-0d3d9b94632ba1e57" -> "ami-09a7535106fbd42d5" # forces replacement
      ~ arn                                  = "arn:aws:ec2:ap-northeast-2:424610772993:instance/i-0274b99caf324f762" -> (known after apply)
      ~ associate_public_ip_address          = true -> (known after apply)
      ~ availability_zone                    = "ap-northeast-2a" -> (known after apply)
      ...
      <중략>
      ...
    }

Plan: 1 to add, 0 to change, 1 to destroy.
aws_instance.instance: Destroying... [id=i-0274b99caf324f762]
aws_instance.instance: Still destroying... [id=i-0274b99caf324f762, 10s elapsed]
aws_instance.instance: Still destroying... [id=i-0274b99caf324f762, 20s elapsed]
aws_instance.instance: Still destroying... [id=i-0274b99caf324f762, 30s elapsed]
aws_instance.instance: Destruction complete after 30s
aws_instance.instance: Creating...
aws_instance.instance: Still creating... [10s elapsed]
aws_instance.instance: Creation complete after 13s [id=i-0e466622e4ba3257b]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
```

<br>

### 1-3-2. `terraform state list`

```bash
mspmanager:~/environment/course-terraform/01_Cloud_Resource/start $ terraform state list
aws_instance.instance
```

<br>

### 1-3-3. `terraform destroy`

- 각 Lab의 실습을 완료하신 후 반드시 `terraform destroy`를 수행하여 생성된 AWS 자원을 삭제해주세요.  

❗❗ `terraform destroy`를 통한 자원 정리를 하지 않는 경우 이후 실습에서 aws resource limit으로 인해 에러가 발생될 수 있습니다. ❗❗ 

🧲 (COPY)  

```bash
terraform destroy -auto-approve
```


---

<br>
<br>

😃 **Lab 1 완료!!!**

<br>

⏩ 다음 실습으로 [이동](../02_Resource_Dependency/README.md)합니다.
