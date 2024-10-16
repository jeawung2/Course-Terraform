# Lab2. Terraform Resource Dependency   

<br>

---
- [Lab2. Terraform Resource Dependency](#lab2-terraform-resource-dependency)
  - [2-1. 실습 목표](#2-1-실습-목표)
  - [2-2. 실습 세부사항](#2-2-실습-세부사항)
    - [2-2-1. `provider.tf`](#2-2-1-providertf)
    - [2-2-2. `main.tf`](#2-2-2-maintf)
    - [2-2-3. `index.html`](#2-2-3-indexhtml)
  - [2-3. 실습 결과](#2-3-실습-결과)
    - [2-3-1. `terraform apply`](#2-3-1-terraform-apply)
    - [2-3-2. `terraform state list`](#2-3-2-terraform-state-list)
    - [2-3-3. `terraform destroy`](#2-3-3-terraform-destroy)
---

## 2-1. 실습 목표

- AWS 프로바이더 관련 블록(terraform, provider)을 별도의 .tf 파일에 정의한다.  
- AWS S3 버킷 리소스를 정의한다.  
  - S3 버킷의 이름은 글로벌하게 유일해야 함으로, Random 리소스를 정의해 문자/숫자로만 된 10자리를 생성한다.  
  - 해당 버킷에 간단한 HTML 코드 오브젝트를 업로드한다. (aws_s3_object 리소스 활용)  
- AWS EC2 인스턴스 리소스 2개를 생성한다.  
  - 두 번째 인스턴스(instance_b)에 S3 버킷을 의존한다. (명시적 종속성 활용)  
- AWS EIP 리소스를 정의하고 첫 번째 인스턴스(instance_a)에 할당한다. (암시적 종속성 활용)  
- 본 실습을 완료하면 아래와 같은 Architecture의 Cloud 자원이 생성된다.

![](../Reference_docs/images/lab/terraform_lab_arhitecture-Lab02.png)
![](/course-terraform/Reference_docs/images/lab/terraform_lab_arhitecture-Lab02.png)

---

## 2-2. 실습 세부사항

### 2-2-1. `provider.tf` 

- Working Directory에 파일 신규 생성
- (main.tf 파일에 주석 처리 되어 있는) terraform 블록 이동
- (main.tf 파일에 주석 처리 되어 있는) aws provider 블록 이동

<br>

### 2-2-2. `main.tf` 

- aws_instance 리소스 (2개 작성)
  - instance_a
    - AMI 이미지: ami-04341a215040f91bb
    - Instance Type: t3.micro
    - Name Tag: instance-a
  - instance_b
    - AMI 이미지: ami-04341a215040f91bb
    - Instance Type: t3.micro
    - Name Tag: instance-b
    - 의존성 주입 (명시적 종속성 활용)
      - aws_s3_bucket 리소스

<br>

- aws_eip 리소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
  - domain 타입은 "vpc"로 설정
  - aws_instance.instance_a 인스턴스에 할당 (암시적 종속성 활용)

<br>

- random 리소스
  - https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
  - 글자 수: 10자
  - 소문자, 숫자 만

<br>

- aws_s3_bucket 리소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
  - bucket: mybucket-[RANDOM Resource Result]

<br>

- aws_s3_object 리소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object
  - bucket: aws_s3_bucket 리소스에 할당 (암시적 종속성 활용)
  - key: index.html
  - source: index.html

<br>

### 2-2-3. `index.html`

- Working Directory에 파일 신규 생성

```html
<h1> hello world </h1>
```

---

## 2-3. 실습 결과

### 2-3-1. `terraform apply`

```bash
mspmanager:~/environment/course-terraform/02_Resource_Dependency/start $ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

...
<중략>
...

Plan: 6 to add, 0 to change, 0 to destroy.
random_string.random: Creating...
random_string.random: Creation complete after 0s [id=03irudxh12]
aws_s3_bucket.bucket: Creating...
aws_instance.instance_a: Creating...
aws_s3_bucket.bucket: Creation complete after 2s [id=mybucket-03irudxh12]
aws_instance.instance_b: Creating...
aws_s3_object.object: Creating...
aws_s3_object.object: Creation complete after 0s [id=index.html]
aws_instance.instance_a: Still creating... [10s elapsed]
aws_instance.instance_a: Creation complete after 12s [id=i-0324f3daf3bdd6865]
aws_eip.eip: Creating...
aws_instance.instance_b: Still creating... [10s elapsed]
aws_eip.eip: Creation complete after 1s [id=eipalloc-06b9fb271a51ff29b]
aws_instance.instance_b: Creation complete after 12s [id=i-04b073fba2b95b01d]

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
mspmanager:~/environment/course-terraform/02_Resource_Dependency/start $
```

<br>

### 2-3-2. `terraform state list`

```bash
mspmanager:~/environment/course-terraform/02_Resource_Dependency/start $ terraform state list
aws_eip.eip
aws_instance.instance_a
aws_instance.instance_b
aws_s3_bucket.bucket
aws_s3_object.object
random_string.random
```

<br>

### 2-3-3. `terraform destroy`

- 각 Lab의 실습을 완료하신 후 반드시 `terraform destroy`를 수행하여 생성된 AWS 자원을 삭제해주세요.  

❗❗ `terraform destroy`를 통한 자원 정리를 하지 않는 경우 이후 실습에서 aws resource limit으로 인해 에러가 발생될 수 있습니다. ❗❗ 

🧲 (COPY)  

```bash
terraform destroy -auto-approve
```

---

<br>
<br>

😃 **Lab 2 완료!!!**

<br>

⏩ 다음 실습으로 [이동](../03_Variable_and_Value/README.md)합니다.

<br>
<br>

<center> <a href="../README.md">[실습 목록]</a> </center>
