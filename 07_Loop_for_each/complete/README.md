# Lab7. Terraform 반복문 - for_each 실습   

<br>

---
- [Lab7. Terraform 반복문 - for\_each 실습](#lab7-terraform-반복문---for_each-실습)
  - [7-1. 실습 목표](#7-1-실습-목표)
  - [7-2. 실습 세부사항](#7-2-실습-세부사항)
    - [7-2-1. `variable.tf`](#7-2-1-variabletf)
    - [7-2-2. `main.tf`](#7-2-2-maintf)
    - [7-2-3. `output.tf`](#7-2-3-outputtf)
  - [7-3. 실습 결과](#7-3-실습-결과)
    - [7-3-1. `terraform apply`](#7-3-1-terraform-apply)
    - [7-3-2. `terraform state list`](#7-3-2-terraform-state-list)
    - [7-3-3. `terraform destroy`](#7-3-3-terraform-destroy)
---

## 7-1. 실습 목표

- for_each 메타 인수(Meta-Argument)를 사용하여 지금까지 구성한 서비스 전체를 서로 다른 환경으로 반복 구축한다.
  - Alpha 프로젝트
    - 서브넷 개수, 서브넷 당 인스턴스 수
    - 인스턴스 타입
  - Beta 프로젝트
    - 서브넷 개수, 서브넷 당 인스턴스 수
    - 인스턴스 타입
- VPC, 보안 그룹, ELB, EC2 모듈에 for_each 반복문을 구성한다.
- for 표현식을 사용하여 여러 프로젝트의 출력 값을 출력 한다.  
- 본 실습을 완료하면 아래와 같은 Architecture의 Cloud 자원이 생성된다.

![](../Reference_docs/images/lab/terraform_lab_arhitecture-Lab07.png)
![](/course-terraform/Reference_docs/images/lab/terraform_lab_arhitecture-Lab07.png)

---

## 7-2. 실습 세부사항

### 7-2-1. `variable.tf`

> 입력 변수는 start 폴더에 미리 정의되어 있다. (추가 작성 필요 없음)

- project_name / project_environment / instance_type 변수 제거
- number_of_instances_per_subnet / number_of_subnets 변수 제거
- project 변수 추가
  - 키: 프로젝트 이름
  - for_each 반복에 사용할 변수

```
variable "project" {
  type = map(any)

  default = {
    proj-alpha = {
      number_of_instances_per_subnet = 2,
      number_of_subnets              = 2,
      instance_type                  = "t3.micro",
      project_environment            = "dev"
    },
    proj-beta = {
      number_of_instances_per_subnet = 1,
      number_of_subnets              = 2,
      instance_type                  = "t3.nano",
      project_environment            = "test"
    }
  }
}
```

<br>

### 7-2-2. `main.tf`

- vpc / instance_security_group / lb_security_group / elb / ec2 모듈 에 for_each 반복문 구성
  - for_each 반복문에 project 변수 할당
  - project 변수의 하위 키에 대해 **인수 값 변경필요**

<br>

### 7-2-3. `output.tf`

- for 표현식을 사용하여 인스턴스 프라이빗 IP, 인스턴스 ID, 로드밸런서 주소를 MAP 형식으로 출력
  - keys 함수 활용 (https://developer.hashicorp.com/terraform/language/functions/keys)
  - { "=>" } 활용  

<br>

---

## 7-3. 실습 결과

### 7-3-1. `terraform apply`

```bash
mspmanager:~/environment/course-terraform/07_Loop_for_each/start $ terraform apply -auto-approve
data.aws_availability_zones.available: Reading...
data.aws_availability_zones.available: Read complete after 1s [id=ap-northeast-2]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

...
<중략>
...

Plan: 68 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_ids          = {
      + proj-alpha = [
          + (known after apply),
          + (known after apply),
          + (known after apply),
          + (known after apply),
        ]
      + proj-beta  = [
          + (known after apply),
          + (known after apply),
        ]
    }
  + instance_private_ips  = {
      + proj-alpha = [
          + (known after apply),
          + (known after apply),
          + (known after apply),
          + (known after apply),
        ]
      + proj-beta  = [
          + (known after apply),
          + (known after apply),
        ]
    }
  + loadbalancer_dns_name = {
      + proj-alpha = (known after apply)
      + proj-beta  = (known after apply)
    }
module.vpc["proj-alpha"].aws_vpc.this[0]: Creating...
module.vpc["proj-beta"].aws_vpc.this[0]: Creating...
module.vpc["proj-alpha"].aws_vpc.this[0]: Still creating... [10s elapsed]
module.vpc["proj-beta"].aws_vpc.this[0]: Still creating... [10s elapsed]
module.vpc["proj-alpha"].aws_vpc.this[0]: Creation complete after 12s [id=vpc-022548e1f4b027a1b]
module.vpc["proj-beta"].aws_vpc.this[0]: Creation complete after 12s [id=vpc-05ecbedb64e821245]

...
<중략>
...

module.elb["proj-beta"].module.elb_attachment.aws_elb_attachment.this[1]: Creation complete after 1s [id=elb-proj-beta-test-20230924055036525200000010]
module.elb["proj-alpha"].module.elb_attachment.aws_elb_attachment.this[0]: Creation complete after 1s [id=elb-proj-alpha-dev-20230924055036549000000012]

Apply complete! Resources: 68 added, 0 changed, 0 destroyed.

Outputs:

instance_ids = {
  "proj-alpha" = [
    "i-067397d3210119825",
    "i-08b6dbb5d2d908c7f",
    "i-01c7a1b4768becee6",
    "i-0c1fcf834efa7940d",
  ]
  "proj-beta" = [
    "i-0ee96cf0b7b8d68bb",
    "i-0237395ffaca56693",
  ]
}
instance_private_ips = {
  "proj-alpha" = [
    "10.0.101.45",
    "10.0.102.220",
    "10.0.101.141",
    "10.0.102.190",
  ]
  "proj-beta" = [
    "10.0.101.205",
    "10.0.102.149",
  ]
}
loadbalancer_dns_name = {
  "proj-alpha" = "elb-proj-alpha-dev-45773352.ap-northeast-2.elb.amazonaws.com"
  "proj-beta" = "elb-proj-beta-test-956360236.ap-northeast-2.elb.amazonaws.com"
}
mspmanager:~/environment/course-terraform/07_Loop_for_each/start $ 
```

<br>

### 7-3-2. `terraform state list`

```bash
mspmanager:~/environment/course-terraform/07_Loop_for_each/start $ terraform state list
data.aws_availability_zones.available
module.ec2["proj-alpha"].data.aws_ami.ubuntu_linux
module.ec2["proj-alpha"].data.cloudinit_config.init
module.ec2["proj-alpha"].aws_instance.instance[0]
module.ec2["proj-alpha"].aws_instance.instance[1]
module.ec2["proj-alpha"].aws_instance.instance[2]
module.ec2["proj-alpha"].aws_instance.instance[3]
module.ec2["proj-beta"].data.aws_ami.ubuntu_linux
module.ec2["proj-beta"].data.cloudinit_config.init
module.ec2["proj-beta"].aws_instance.instance[0]
module.ec2["proj-beta"].aws_instance.instance[1]
module.vpc["proj-alpha"].aws_default_network_acl.this[0]
module.vpc["proj-alpha"].aws_default_route_table.default[0]
module.vpc["proj-alpha"].aws_default_security_group.this[0]
module.vpc["proj-alpha"].aws_eip.nat[0]
module.vpc["proj-alpha"].aws_internet_gateway.this[0]
module.vpc["proj-alpha"].aws_nat_gateway.this[0]
module.vpc["proj-alpha"].aws_route.private_nat_gateway[0]
module.vpc["proj-alpha"].aws_route.public_internet_gateway[0]
module.vpc["proj-alpha"].aws_route_table.private[0]
module.vpc["proj-alpha"].aws_route_table.public[0]
module.vpc["proj-alpha"].aws_route_table_association.private[0]
module.vpc["proj-alpha"].aws_route_table_association.private[1]
module.vpc["proj-alpha"].aws_route_table_association.public[0]
module.vpc["proj-alpha"].aws_route_table_association.public[1]
module.vpc["proj-alpha"].aws_subnet.private[0]
module.vpc["proj-alpha"].aws_subnet.private[1]
module.vpc["proj-alpha"].aws_subnet.public[0]
module.vpc["proj-alpha"].aws_subnet.public[1]
module.vpc["proj-alpha"].aws_vpc.this[0]
module.vpc["proj-beta"].aws_default_network_acl.this[0]
module.vpc["proj-beta"].aws_default_route_table.default[0]
module.vpc["proj-beta"].aws_default_security_group.this[0]
module.vpc["proj-beta"].aws_eip.nat[0]
module.vpc["proj-beta"].aws_internet_gateway.this[0]
module.vpc["proj-beta"].aws_nat_gateway.this[0]
module.vpc["proj-beta"].aws_route.private_nat_gateway[0]
module.vpc["proj-beta"].aws_route.public_internet_gateway[0]
module.vpc["proj-beta"].aws_route_table.private[0]
module.vpc["proj-beta"].aws_route_table.public[0]
module.vpc["proj-beta"].aws_route_table_association.private[0]
module.vpc["proj-beta"].aws_route_table_association.private[1]
module.vpc["proj-beta"].aws_route_table_association.public[0]
module.vpc["proj-beta"].aws_route_table_association.public[1]
module.vpc["proj-beta"].aws_subnet.private[0]
module.vpc["proj-beta"].aws_subnet.private[1]
module.vpc["proj-beta"].aws_subnet.public[0]
module.vpc["proj-beta"].aws_subnet.public[1]
module.vpc["proj-beta"].aws_vpc.this[0]
module.elb["proj-alpha"].module.elb.aws_elb.this[0]
module.elb["proj-alpha"].module.elb_attachment.aws_elb_attachment.this[0]
module.elb["proj-alpha"].module.elb_attachment.aws_elb_attachment.this[1]
module.elb["proj-alpha"].module.elb_attachment.aws_elb_attachment.this[2]
module.elb["proj-alpha"].module.elb_attachment.aws_elb_attachment.this[3]
module.elb["proj-beta"].module.elb.aws_elb.this[0]
module.elb["proj-beta"].module.elb_attachment.aws_elb_attachment.this[0]
module.elb["proj-beta"].module.elb_attachment.aws_elb_attachment.this[1]
module.instance_security_group["proj-alpha"].module.sg.aws_security_group.this_name_prefix[0]
module.instance_security_group["proj-alpha"].module.sg.aws_security_group_rule.egress_rules[0]
module.instance_security_group["proj-alpha"].module.sg.aws_security_group_rule.ingress_rules[0]
module.instance_security_group["proj-alpha"].module.sg.aws_security_group_rule.ingress_with_self[0]
module.instance_security_group["proj-beta"].module.sg.aws_security_group.this_name_prefix[0]
module.instance_security_group["proj-beta"].module.sg.aws_security_group_rule.egress_rules[0]
module.instance_security_group["proj-beta"].module.sg.aws_security_group_rule.ingress_rules[0]
module.instance_security_group["proj-beta"].module.sg.aws_security_group_rule.ingress_with_self[0]
module.lb_security_group["proj-alpha"].module.sg.aws_security_group.this_name_prefix[0]
module.lb_security_group["proj-alpha"].module.sg.aws_security_group_rule.egress_rules[0]
module.lb_security_group["proj-alpha"].module.sg.aws_security_group_rule.ingress_rules[0]
module.lb_security_group["proj-alpha"].module.sg.aws_security_group_rule.ingress_with_self[0]
module.lb_security_group["proj-beta"].module.sg.aws_security_group.this_name_prefix[0]
module.lb_security_group["proj-beta"].module.sg.aws_security_group_rule.egress_rules[0]
module.lb_security_group["proj-beta"].module.sg.aws_security_group_rule.ingress_rules[0]
module.lb_security_group["proj-beta"].module.sg.aws_security_group_rule.ingress_with_self[0]
```

<br>

### 7-3-3. `terraform destroy`

- 각 Lab의 실습을 완료하신 후 반드시 `terraform destroy`를 수행하여 생성된 AWS 자원을 삭제해주세요.  

❗❗ `terraform destroy`를 통한 자원 정리를 하지 않는 경우 이후 실습에서 aws resource limit으로 인해 에러가 발생될 수 있습니다. ❗❗ 

🧲 (COPY)  

```bash
terraform destroy -auto-approve
```

> ❗실습 종료 후 `terraform destroy` 수행 시 아래와 같은 warnning 메세지가 발생하는 것이 정상입니다. 리소스 삭제는 정상적으로 수행되니 무시하셔도 됩니다.❗
>
> ```bash
> ╷
> │ Warning: EC2 Default Network ACL (acl-0cca5bed276f6a223) not deleted, removing from state
> │ 
> ╵
> ╷
> │ Warning: cleaning up ELB Classic Load Balancer (elb-myproject-development) ENIs: 2 errors occurred:
> │       * detaching EC2 Network Interface (eni-03b2e35974fb79362/eni-attach-069966dd31b824275): AuthFailure: You do not have permission to access the specified resource.
> │       status code: 400, request id: 475dddbe-1fb5-4909-a49e-96db8e87b89d
> │       * detaching EC2 Network Interface (eni-0e08805630f395795/eni-attach-03dcc7e7200ce59ed): AuthFailure: You do not have permission to access the specified resource.
> │       status code: 400, request id: 9de29539-57ee-46d0-910c-0af7de2d3ec4
> │ 
> ╵
> ```

<br>

- Module을 활용한 Lab의 경우 다운로드된 provider의 용량이 크기 때문에 이후 실습을 원활하게 진행하기 위해서 `.terraform` 폴더를 삭제해주도록 하자!  

🧲 (COPY)  

```bash
rm -rf ~/environment/course-terraform/07_Loop_for_each/start/.terraform*
```

---

<br>
<br>

😃 **Lab 7 완료!!!**

<br>

⏩ 실습이 모두 완료되었습니다. 모두 수고하셨습니다!

<br>
<br>

<center> <a href="../README.md">[목록]</a> </center>
