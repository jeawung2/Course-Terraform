# Lab6. Terraform 반복문 - count 실습   

<br>

---
- [Lab6. Terraform 반복문 - count 실습](#lab6-terraform-반복문---count-실습)
  - [6-1. 실습 목표](#6-1-실습-목표)
  - [6-2. 실습 세부사항](#6-2-실습-세부사항)
    - [6-2-1. `variable.tf`](#6-2-1-variabletf)
    - [6-2-2. `main.tf`](#6-2-2-maintf)
    - [6-2-3. `output.tf`](#6-2-3-outputtf)
  - [6-3. 실습 결과](#6-3-실습-결과)
    - [6-3-1. `terraform apply`](#6-3-1-terraform-apply)
    - [6-3-2. `terraform state list`](#6-3-2-terraform-state-list)
    - [6-3-3. `terraform destroy`](#6-3-3-terraform-destroy)
---

## 6-1. 실습 목표

- Count 메타 인수를 이용하여 리소스를 반복 구성 한다.
  - 반복에 사용하기 위한 입력 변수를 사용한다.
    - number_of_instances_per_subnet: 서브넷 당 인스턴스 수
    - number_of_subnets: 서브넷 수
      - 서브넷은 각 리전의 가용 영역에 할당된다.
  - 반복 관련 변수를 이용하여 리소스 생성 시 참조한다.
    - VPC의 서브넷
    - ELB의 타겟 인스턴스
  - 인스턴스를 Count 메타 인수를 이용해 여러 리소스를 생성한다.  
- 본 실습을 완료하면 아래와 같은 Architecture의 Cloud 자원이 생성된다.

![](../Reference_docs/images/lab/terraform_lab_arhitecture-Lab06.png)
![](/course-terraform/Reference_docs/images/lab/terraform_lab_arhitecture-Lab06.png)

---

## 6-2. 실습 세부사항

### 6-2-1. `variable.tf`

> 입력 변수는 start 폴더에 미리 정의되어 있다. (추가 작성 필요 없음)

- number_of_instances_per_subnet 변수 추가
- number_of_subnets 변수 추가

<br>

### 6-2-2. `main.tf`

- vpc 모듈
  - private_subnets, public_subnets
    - slice 함수 사용 : https://developer.hashicorp.com/terraform/language/functions/slice
    - number_of_subnets 변수로 필요한 서브넷 만 생성

<br>

- elb 모듈
  - 인스턴스 개수: 변수 참조해 총 인스턴스 개수 계산
    - number_of_instances_per_subnet 변수
    - number_of_subnets 변수
  - 인스턴스 ID
    - 직접 인스턴스 ID 하나하나 지정하지 않고 한번에 지정할 수 있게 구성
    - ("*" 문자를 활용하여 id list를 구성)

<br>

- aws_instance 리소스
  - 두개 각 리소스를 count 반복을 적용해 통합
  - count: 변수 참조해 총 인스턴스 개수 계산
    - number_of_instances_per_subnet 변수
    - number_of_subnets 변수
  - subnet_id: 프라이빗 서브넷에 고르게 분배
    - count.index를 number_of_subnet 변수로 나머지 연산

<br>

### 6-2-3. `output.tf`

- instance_private_ips
  - 모든 인스턴스의 프라이빗 IP를 목록으로 출력("*" 문자를 활용)

<br>

- instance_ids
  - 모든 인스턴스의 인스턴스 ID를 목록으로 출력("*" 문자를 활용)

<br>

---

## 6-3. 실습 결과

### 6-3-1. `terraform apply`

```bash
mspmanager:~/environment/course-terraform/06_Loop_count/start $ terraform apply -auto-approve
data.cloudinit_config.init: Reading...
data.cloudinit_config.init: Read complete after 0s [id=2381588995]
data.aws_ami.ubuntu_linux: Reading...
data.aws_availability_zones.available: Reading...
data.aws_availability_zones.available: Read complete after 0s [id=ap-northeast-2]
data.aws_ami.ubuntu_linux: Read complete after 0s [id=ami-003a709e1e4ce3729]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

...
<중략>
...

Plan: 32 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_ids          = [
      + (known after apply),
      + (known after apply),
    ]
  + instance_private_ips  = [
      + (known after apply),
      + (known after apply),
    ]
  + loadbalancer_dns_name = (known after apply)
module.vpc.aws_vpc.this[0]: Creating...
module.vpc.aws_vpc.this[0]: Still creating... [10s elapsed]
module.vpc.aws_vpc.this[0]: Creation complete after 11s [id=vpc-0847780959f434343]
module.vpc.aws_subnet.private[1]: Creating...
module.vpc.aws_internet_gateway.this[0]: Creating...
module.vpc.aws_route_table.public[0]: Creating...
module.vpc.aws_default_network_acl.this[0]: Creating...
module.vpc.aws_default_route_table.default[0]: Creating...
module.vpc.aws_default_security_group.this[0]: Creating...
module.vpc.aws_subnet.private[0]: Creating...
module.vpc.aws_route_table.private[0]: Creating...
module.vpc.aws_subnet.public[1]: Creating...
module.vpc.aws_subnet.public[0]: Creating...
module.vpc.aws_default_route_table.default[0]: Creation complete after 1s [id=rtb-0fad5bca3860d916a]
module.lb_security_group.module.sg.aws_security_group.this_name_prefix[0]: Creating...
module.vpc.aws_internet_gateway.this[0]: Creation complete after 1s [id=igw-0428e037009833886]
module.instance_security_group.module.sg.aws_security_group.this_name_prefix[0]: Creating...
module.vpc.aws_route_table.public[0]: Creation complete after 1s [id=rtb-0f44a28814cce720f]
module.vpc.aws_eip.nat[0]: Creating...
module.vpc.aws_route_table.private[0]: Creation complete after 1s [id=rtb-0070fbce43ccb21dc]
module.vpc.aws_route.public_internet_gateway[0]: Creating...
module.vpc.aws_subnet.public[1]: Creation complete after 1s [id=subnet-0a0157caff5ee3b98]
module.vpc.aws_subnet.public[0]: Creation complete after 1s [id=subnet-00f580f3656580a34]
module.vpc.aws_route_table_association.public[0]: Creating...
module.vpc.aws_route_table_association.public[1]: Creating...
module.vpc.aws_subnet.private[0]: Creation complete after 1s [id=subnet-02523babd69fc0562]
module.vpc.aws_subnet.private[1]: Creation complete after 1s [id=subnet-0dc44bc0b7b7aa19f]
module.vpc.aws_route_table_association.private[0]: Creating...
module.vpc.aws_route_table_association.private[1]: Creating...
module.vpc.aws_route_table_association.public[1]: Creation complete after 0s [id=rtbassoc-09f2e967e0406b447]
module.vpc.aws_eip.nat[0]: Creation complete after 0s [id=eipalloc-01962ac0e4a5d41f1]
module.vpc.aws_default_network_acl.this[0]: Creation complete after 1s [id=acl-09e98783e43b30d70]
module.vpc.aws_route_table_association.public[0]: Creation complete after 0s [id=rtbassoc-03934048dcd093cdc]
module.vpc.aws_nat_gateway.this[0]: Creating...
module.vpc.aws_route.public_internet_gateway[0]: Creation complete after 0s [id=r-rtb-0f44a28814cce720f1080289494]
module.vpc.aws_route_table_association.private[0]: Creation complete after 0s [id=rtbassoc-027b02d6498193100]
module.vpc.aws_route_table_association.private[1]: Creation complete after 0s [id=rtbassoc-060de0b436ef319b1]
module.vpc.aws_default_security_group.this[0]: Creation complete after 2s [id=sg-0f09448ae10b4b62e]
module.lb_security_group.module.sg.aws_security_group.this_name_prefix[0]: Creation complete after 1s [id=sg-0f61500d0848239c0]
module.lb_security_group.module.sg.aws_security_group_rule.ingress_with_self[0]: Creating...
module.lb_security_group.module.sg.aws_security_group_rule.ingress_rules[0]: Creating...
module.lb_security_group.module.sg.aws_security_group_rule.egress_rules[0]: Creating...
module.elb.module.elb.aws_elb.this[0]: Creating...
module.instance_security_group.module.sg.aws_security_group.this_name_prefix[0]: Creation complete after 1s [id=sg-09cd169c12b87302f]
module.instance_security_group.module.sg.aws_security_group_rule.ingress_with_self[0]: Creating...
module.instance_security_group.module.sg.aws_security_group_rule.egress_rules[0]: Creating...
module.instance_security_group.module.sg.aws_security_group_rule.ingress_rules[0]: Creating...
module.lb_security_group.module.sg.aws_security_group_rule.ingress_with_self[0]: Creation complete after 0s [id=sgrule-224877433]
module.instance_security_group.module.sg.aws_security_group_rule.ingress_with_self[0]: Creation complete after 0s [id=sgrule-2323187164]
module.instance_security_group.module.sg.aws_security_group_rule.ingress_rules[0]: Creation complete after 1s [id=sgrule-3177292514]
module.lb_security_group.module.sg.aws_security_group_rule.ingress_rules[0]: Creation complete after 1s [id=sgrule-4026027533]
module.lb_security_group.module.sg.aws_security_group_rule.egress_rules[0]: Creation complete after 1s [id=sgrule-1349801772]
module.instance_security_group.module.sg.aws_security_group_rule.egress_rules[0]: Creation complete after 1s [id=sgrule-1609917818]
module.elb.module.elb.aws_elb.this[0]: Creation complete after 5s [id=elb-myproject-development]
module.vpc.aws_nat_gateway.this[0]: Still creating... [10s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [20s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [30s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [40s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [50s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m0s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m10s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m20s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m30s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m40s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m50s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [2m0s elapsed]
module.vpc.aws_nat_gateway.this[0]: Creation complete after 2m4s [id=nat-0d9b47dfb80f8479a]
module.vpc.aws_route.private_nat_gateway[0]: Creating...
module.vpc.aws_route.private_nat_gateway[0]: Creation complete after 1s [id=r-rtb-0070fbce43ccb21dc1080289494]
aws_instance.instance[0]: Creating...
aws_instance.instance[1]: Creating...
aws_instance.instance[0]: Still creating... [10s elapsed]
aws_instance.instance[1]: Still creating... [10s elapsed]
aws_instance.instance[1]: Creation complete after 12s [id=i-07f3c06bf49f500de]
aws_instance.instance[0]: Creation complete after 12s [id=i-0c38f07f9e30291eb]
module.elb.module.elb_attachment.aws_elb_attachment.this[1]: Creating...
module.elb.module.elb_attachment.aws_elb_attachment.this[0]: Creating...
module.elb.module.elb_attachment.aws_elb_attachment.this[0]: Creation complete after 0s [id=elb-myproject-development-20230924053522923700000006]
module.elb.module.elb_attachment.aws_elb_attachment.this[1]: Creation complete after 0s [id=elb-myproject-development-20230924053522977900000007]

Apply complete! Resources: 32 added, 0 changed, 0 destroyed.

Outputs:

instance_ids = [
  "i-0c38f07f9e30291eb",
  "i-07f3c06bf49f500de",
]
instance_private_ips = [
  "10.0.101.115",
  "10.0.102.207",
]
loadbalancer_dns_name = "elb-myproject-development-1156156387.ap-northeast-2.elb.amazonaws.com"
mspmanager:~/environment/course-terraform/06_Loop_count/start $ 
```

<br>

### 6-3-2. `terraform state list`

```bash
mspmanager:~/environment/course-terraform/06_Loop_count/start $ terraform state list
data.aws_ami.ubuntu_linux
data.aws_availability_zones.available
data.cloudinit_config.init
aws_instance.instance[0]
aws_instance.instance[1]
module.vpc.aws_default_network_acl.this[0]
module.vpc.aws_default_route_table.default[0]
module.vpc.aws_default_security_group.this[0]
module.vpc.aws_eip.nat[0]
module.vpc.aws_internet_gateway.this[0]
module.vpc.aws_nat_gateway.this[0]
module.vpc.aws_route.private_nat_gateway[0]
module.vpc.aws_route.public_internet_gateway[0]
module.vpc.aws_route_table.private[0]
module.vpc.aws_route_table.public[0]
module.vpc.aws_route_table_association.private[0]
module.vpc.aws_route_table_association.private[1]
module.vpc.aws_route_table_association.public[0]
module.vpc.aws_route_table_association.public[1]
module.vpc.aws_subnet.private[0]
module.vpc.aws_subnet.private[1]
module.vpc.aws_subnet.public[0]
module.vpc.aws_subnet.public[1]
module.vpc.aws_vpc.this[0]
module.elb.module.elb.aws_elb.this[0]
module.elb.module.elb_attachment.aws_elb_attachment.this[0]
module.elb.module.elb_attachment.aws_elb_attachment.this[1]
module.instance_security_group.module.sg.aws_security_group.this_name_prefix[0]
module.instance_security_group.module.sg.aws_security_group_rule.egress_rules[0]
module.instance_security_group.module.sg.aws_security_group_rule.ingress_rules[0]
module.instance_security_group.module.sg.aws_security_group_rule.ingress_with_self[0]
module.lb_security_group.module.sg.aws_security_group.this_name_prefix[0]
module.lb_security_group.module.sg.aws_security_group_rule.egress_rules[0]
module.lb_security_group.module.sg.aws_security_group_rule.ingress_rules[0]
module.lb_security_group.module.sg.aws_security_group_rule.ingress_with_self[0]
```

<br>

### 6-3-3. `terraform destroy`

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
rm -rf ~/environment/course-terraform/06_Loop_count/start/.terraform*
```

---

<br>
<br>

😃 **Lab 6 완료!!!**

<br>

⏩ 다음 실습으로 [이동](../07_Loop_for_each/README.md)합니다.

<br>
<br>

<center> <a href="../README.md">[목록]</a> </center>
