# Lab3. Terraform 변수 및 값 활용 실습  

<br>

---
- [Lab3. Terraform 변수 및 값 활용 실습](#lab3-terraform-변수-및-값-활용-실습)
  - [3-1. 실습 목표](#3-1-실습-목표)
  - [3-2. 실습 세부사항](#3-2-실습-세부사항)
    - [3-2-1. 입력 변수 관련](#3-2-1-입력-변수-관련)
      - [3-2-1-1. `variable.tf`](#3-2-1-1-variabletf)
      - [3-2-1-2. `provider.tf`](#3-2-1-2-providertf)
      - [3-2-1-3. `main.tf`](#3-2-1-3-maintf)
      - [3-2-1-4. `terraform.tfvars`](#3-2-1-4-terraformtfvars)
    - [3-2-2. 출력 값 관련](#3-2-2-출력-값-관련)
      - [3-2-2-1. `output.tf`](#3-2-2-1-outputtf)
    - [3-2-3. 로컬 값 관련](#3-2-3-로컬-값-관련)
      - [3-2-3-1. `main.tf`](#3-2-3-1-maintf)
      - [3-2-3-2. `provider.tf`](#3-2-3-2-providertf)
  - [3-3. 실습 결과](#3-3-실습-결과)
    - [3-3-1. `terraform apply`](#3-3-1-terraform-apply)
    - [3-3-2. `terraform state list`](#3-3-2-terraform-state-list)
    - [3-3-3. `terraform destroy`](#3-3-3-terraform-destroy)
---

## 3-1. 실습 목표

- 변수를 사용하여 리소스를 배포한다.
  - 입력 변수(variable): 입력 변수는 variable.tf 파일에 미리 정의되어 있다.
  - 출력 값(output value): output.tf 파일에 인스턴스의 Public IP/Private IP/Elastic IP를 출력 한다.
  - 로컬 값(local value): main.tf 파일에 리소스에 부여할 태그를 로컬 값(Local Value)으로 구성 한다.
- 본 실습을 완료하면 아래와 같은 Architecture의 Cloud 자원이 생성된다.

![](../Reference_docs/images/lab/terraform_lab_arhitecture-Lab03.png)
![](/course-terraform/Reference_docs/images/lab/terraform_lab_arhitecture-Lab03.png)

---

## 3-2. 실습 세부사항

### 3-2-1. 입력 변수 관련

#### 3-2-1-1. `variable.tf`

> 입력 변수는 start 폴더에 미리 정의되어 있다. (추가 작성 필요 없음)

- `aws_region`: 리전
- `project_name`: 프로젝트 이름
- `project_environment`: 프로젝트 환경
- `ami_image`: 이미지 AMI ID
  - Map Type의 변수. Key로 `aws_region`을 받을 수 있다.
- `instance_type`: 인스턴스 타입

<br>

#### 3-2-1-2. `provider.tf`

- aws 프로바이더
  - aws_region 변수 참조

<br>

#### 3-2-1-3. `main.tf`

- aws_instance
  - AMI 이미지 변수 참조
  - 인스턴스 타입 변수 참조

<br>

#### 3-2-1-4. `terraform.tfvars`

- Working Directory에 신규 파일 생성 필요  
- aws_region 변수 값 = 서울(ap-northeast-2) 리전 설정

<br>

### 3-2-2. 출력 값 관련

#### 3-2-2-1. `output.tf`

- 인스턴스 Public IP 출력
- 인스턴스 Private IP 출력
- 인스턴스 Elastic IP 출력

> 👉 output으로 출력할 value 값은 provider 공식 문서의 Argument/Attribute Reference 항목을 참고하여 작성해보자.  
> - Public/Private IP : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
> - EIP : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip

<br>

### 3-2-3. 로컬 값 관련

#### 3-2-3-1. `main.tf`

- common_tags: 모든 리소스에 할당할 공통 태그
  - Project: 프로젝트 이름 변수 참조
  - Environment: 프로젝트 환경 변수 참조
  
- suffix_name: 각 리소스의 Name 태그에 할당할 suffix 태그
  - "<프로젝트 이름>-<프로젝트 환경>"

- aws_instance / aws_eip
  - 리소스에 Name 태그를 suffix_name 로컬 값 지정

<br>

#### 3-2-3-2. `provider.tf`

- aws 프로바이더
  - common_tags 로컬 값 기본 태그로 지정

<br>

---

## 3-3. 실습 결과

### 3-3-1. `terraform apply`

```bash
mspmanager:~/environment/course-terraform/03_Variable_and_Value/start $ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

...
<중략>
...

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_elastic_ip_a = (known after apply)
  + instance_elastic_ip_b = (known after apply)
  + instance_private_ip_a = (known after apply)
  + instance_private_ip_b = (known after apply)
  + instance_public_ip_a  = (known after apply)
  + instance_public_ip_b  = (known after apply)
aws_instance.instance_b: Creating...
aws_instance.instance_a: Creating...
aws_instance.instance_b: Still creating... [10s elapsed]
aws_instance.instance_a: Still creating... [10s elapsed]
aws_instance.instance_a: Creation complete after 12s [id=i-0c0e7e70d7e9a33d4]
aws_eip.eip_a: Creating...
aws_instance.instance_b: Creation complete after 12s [id=i-0def58db9aa9b30ae]
aws_eip.eip_b: Creating...
aws_eip.eip_b: Creation complete after 1s [id=eipalloc-0800a64d43068f9a3]
aws_eip.eip_a: Creation complete after 1s [id=eipalloc-00f53bda531fd520d]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

instance_elastic_ip_a = "3.37.20.245"
instance_elastic_ip_b = "43.200.26.32"
instance_private_ip_a = "172.31.46.96"
instance_private_ip_b = "172.31.46.14"
instance_public_ip_a = "15.164.102.126"
instance_public_ip_b = "13.209.42.168"
mspmanager:~/environment/course-terraform/03_Variable_and_Value/start $
```

> 🤔 Output 결과를 보면 동일 instance의 `elastic ip`와 `public ip`의 출력값이 다른 것을 알 수 있다. 하지만 AWS Console에서 확인해보면 아래 그림과 같이 동일한 IP Address로 확인된다. 이유가 무엇일까❓  
> ![](../Reference_docs/images/lab/eip_publicip.png)
> ![](/course-terraform/Reference_docs/images/lab/eip_publicip.png)
> 
> 👉 Terraform Output 결과와 AWS Console의 결과가 서로 다르게 보이는 이유는 자원 생성 순서와 연관이 있다. Lab3. 실습 수행시 AWS에서 자원(instance, public ip, elastic ip)이 생성되는 순서는 다음과 같다.
> 1. instance 리소스가 생성된다.(이때 public ip와 private ip가 자동으로 할당된다.)
> 2. instance에 할당된 public ip와 private ip가 terraform output에 저장된다.
> 3. elastic ip 리소스가 생성된다.
> 4. 생성된 elastic ip가 terraform output에 저장된다.
> 5. elastic ip가 instance에 붙여지고, 이 때 instance의 public ip가 elastic ip로 변경된다.
> 
> 즉, terraform output의 값은 해당 값이 생성될 때 저장되고 추후 변경되더라고 갱신되지 않기 때문에 현재 값과 다르게 보일 수 있다.
> 참고로 이렇게 이후에 변경된 값을 갱신하기 위해선 아래 명령어로 state를 갱신해주면 된다.
> ```bash
> terraform refresh
> ```

<br>

### 3-3-2. `terraform state list`

```bash
mspmanager:~/environment/course-terraform/03_Variable_and_Value/start $ terraform state list
aws_eip.eip_a
aws_eip.eip_b
aws_instance.instance_a
aws_instance.instance_b
```

<br>

### 3-3-3. `terraform destroy`

- 각 Lab의 실습을 완료하신 후 반드시 `terraform destroy`를 수행하여 생성된 AWS 자원을 삭제해주세요.  

❗❗ `terraform destroy`를 통한 자원 정리를 하지 않는 경우 이후 실습에서 aws resource limit으로 인해 에러가 발생될 수 있습니다. ❗❗ 

🧲 (COPY)  

```bash
terraform destroy -auto-approve
```

---

<br>
<br>

😃 **Lab 3 완료!!!**

<br>

⏩ 다음 실습으로 [이동](../04_Data_Source_and_Read_File/README.md)합니다.

<br>
<br>

<center> <a href="../README.md">[목록]</a> </center>
