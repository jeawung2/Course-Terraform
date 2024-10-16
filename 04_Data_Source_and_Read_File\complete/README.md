# Lab4. Data Source 및 File 참조 실습   

<br>

---
- [Lab4. Data Source 및 File 참조 실습](#lab4-data-source-및-file-참조-실습)
  - [4-1. 실습 목표](#4-1-실습-목표)
  - [4-2. 실습 세부사항](#4-2-실습-세부사항)
    - [4-2-1. `main.tf`](#4-2-1-maintf)
    - [4-2-2. `variable.tf`](#4-2-2-variabletf)
    - [4-2-3. `script/userdata.sh`](#4-2-3-scriptuserdatash)
    - [4-2-4. `template/userdata.tftpl`](#4-2-4-templateuserdatatftpl)
  - [4-3. 실습 결과](#4-3-실습-결과)
    - [4-3-1. `terraform apply`](#4-3-1-terraform-apply)
    - [4-3-2. `terraform state list`](#4-3-2-terraform-state-list)
    - [4-3-3. `terraform destroy`](#4-3-3-terraform-destroy)
---

## 4-1. 실습 목표

- AMI 이미지를 입력 변수가 아닌, aws_ami 데이터 소스를 이용하여 참조한다.
- AWS 인스턴스의 유저 데이터를 이용해 웹 서버로 구성한다.
  - 유저 데이터 구성은 다음 중 하나를 사용할 수 있다. (본 실습의 complete 예시에선 이 중 cloudinit_config 데이터 소스를 활용했음을 참고하자.)
    - Heredoc
    - file 함수
    - templatefile 함수
    - cloudinit_config 데이터 소스
- 웹 서버 구성에 따른 접속을 위해 보안 그룹을 구성한다.  
- 본 실습을 완료하면 아래와 같은 Architecture의 Cloud 자원이 생성된다.

![](../Reference_docs/images/lab/terraform_lab_arhitecture-Lab04.png)
![](/course-terraform/Reference_docs/images/lab/terraform_lab_arhitecture-Lab04.png)

---

## 4-2. 실습 세부사항

### 4-2-1. `main.tf`

- aws_ami 데이터 소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
  - 최신 버전
  - 소유자: amazon
  - 필터
    - 이름
    - ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*

<br>

- cloudinit_config 데이터 소스 (cloudinit provider 사용시 활용)
  - https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config
  - gzip 비활성
  - base64 인코딩 활성
  - userdata.sh 스트립트 파일

<br>

- aws_instance 리소스
  - ami : aws_ami 데이터 소스의 image_id 속성 값을 참조하도록 수정
  - vpc_security_group_ids : aws_security_group 리소스를 참조하도록 수정 (List 형식)
  - user_data
    - 아래 4가지 방법 중 하나 선택하여 구성
      - Heredoc
      - file 함수
      - templatefile 함수
      - cloudinit_config 데이터 소스 (complete 예시)

<br>

- aws_security_group 리소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
  - egress: 모두 허용
  - ingress: tcp, 80, 모든 CIDR 허용

<br>

### 4-2-2. `variable.tf`

- AMI 이미지 변수 제거

<br>

### 4-2-3. `script/userdata.sh`

> - file 함수, cloudinit_config 데이터 소스 사용 시 활용 가능
> - Working Directory에 폴더/파일 신규 생성

```bash
#!/bin/bash
apt update
apt install -y apache2
curl http://169.254.169.254/latest/meta-data/instance-id -o /var/www/html/index.html
```

<br>

### 4-2-4. `template/userdata.tftpl`

> - templatefile 함수 사용 시 활용 가능
> - Working Directory에 폴더/파일 신규 생성

```bash
#!/bin/bash
apt update
apt install -y apache2
echo ${message} > /var/www/html/index.html
```

<br>

---

## 4-3. 실습 결과

### 4-3-1. `terraform apply`

```bash
mspmanager:~/environment/course-terraform/04_Data_Source_and_Read_File/start $ terraform apply -auto-approve
data.cloudinit_config.init: Reading...
data.cloudinit_config.init: Read complete after 0s [id=2381588995]
data.aws_ami.ubuntu_linux: Reading...
data.aws_ami.ubuntu_linux: Read complete after 1s [id=ami-003a709e1e4ce3729]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

...
<중략>
...

Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_elastic_ip_a = (known after apply)
  + instance_elastic_ip_b = (known after apply)
  + instance_private_ip_a = (known after apply)
  + instance_private_ip_b = (known after apply)
  + instance_public_ip_a  = (known after apply)
  + instance_public_ip_b  = (known after apply)
aws_security_group.web: Creating...
aws_security_group.web: Creation complete after 2s [id=sg-054bf627b74d4460a]
aws_instance.instance_a: Creating...
aws_instance.instance_b: Creating...
aws_instance.instance_a: Still creating... [10s elapsed]
aws_instance.instance_b: Still creating... [10s elapsed]
aws_instance.instance_b: Creation complete after 12s [id=i-0c65acda0eda7e449]
aws_eip.eip_b: Creating...
aws_instance.instance_a: Creation complete after 12s [id=i-0cf6575f48d5dc80f]
aws_eip.eip_a: Creating...
aws_eip.eip_b: Creation complete after 1s [id=eipalloc-0a07a0b7c3ae0fcfb]
aws_eip.eip_a: Creation complete after 1s [id=eipalloc-034875158672046ac]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

instance_elastic_ip_a = "43.202.8.5"
instance_elastic_ip_b = "3.37.103.71"
instance_private_ip_a = "172.31.41.176"
instance_private_ip_b = "172.31.43.230"
instance_public_ip_a = "3.39.187.109"
instance_public_ip_b = "3.34.198.62"
mspmanager:~/environment/course-terraform/04_Data_Source_and_Read_File/start $
```

<br>

### 4-3-2. `terraform state list`

```bash
mspmanager:~/environment/course-terraform/04_Data_Source_and_Read_File/start $ terraform state list
data.aws_ami.ubuntu_linux
data.cloudinit_config.init
aws_eip.eip_a
aws_eip.eip_b
aws_instance.instance_a
aws_instance.instance_b
aws_security_group.web
```

<br>

### 4-3-3. `terraform destroy`

- 각 Lab의 실습을 완료하신 후 반드시 `terraform destroy`를 수행하여 생성된 AWS 자원을 삭제해주세요.  

❗❗ `terraform destroy`를 통한 자원 정리를 하지 않는 경우 이후 실습에서 aws resource limit으로 인해 에러가 발생될 수 있습니다. ❗❗ 

🧲 (COPY)  

```bash
terraform destroy -auto-approve
```

---

<br>
<br>

😃 **Lab 4 완료!!!**

<br>

⏩ 다음 실습으로 [이동](../05_Module/README.md)합니다.

<br>
<br>

<center> <a href="../README.md">[목록]</a> </center>
