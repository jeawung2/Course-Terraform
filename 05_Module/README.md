# Lab5. Terraform Module 실습   

<br>

---
- [Lab5. Terraform Module 실습](#lab5-terraform-module-실습)
  - [5-1. 실습 목표](#5-1-실습-목표)
  - [5-2. 실습 세부사항](#5-2-실습-세부사항)
    - [5-2-1. `variable.tf`](#5-2-1-variabletf)
    - [5-2-2. `main.tf`](#5-2-2-maintf)
    - [5-2-3. `output.tf`](#5-2-3-outputtf)
  - [5-3. 실습 결과](#5-3-실습-결과)
    - [5-3-1. `terraform apply`](#5-3-1-terraform-apply)
    - [5-3-2. `terraform state list`](#5-3-2-terraform-state-list)
    - [5-3-3. `terraform destroy`](#5-3-3-terraform-destroy)
---

## 5-1. 실습 목표

- Terraform Registry에 공개된 공식 AWS 모듈을 이용하여 리소스를 배포한다.
  - VPC 모듈을 이용해 VPC 및 서브넷, 라우트 테이블 등을 구성한다.
    - 참고로 앞선 Lab에선 기본 VPC(Default VPC)를 사용했다.
  - 보안 그룹(Security Group) 모듈을 이용해 보안 그룹을 구성한다.
    - EC2 인스턴스의 웹 접속 허용
    - 로드 밸런서용 웹 접속 허용
  - ELB 모듈(Classic LoadBalancer)을 이용해 로드 밸런서를 구성한다.
    - 기존 두 개의 인스턴스를 타겟으로 설정한다.
- EC2 인스턴스 리소스는 모듈로 생성한 VPC 및 보안 그룹의 Output 값을 사용한다.
- 출력 값
  - EC2의 Private IP 및 Instance ID를 출력한다.
  - 로드 밸런서의 주소를 출력한다.

> 참고: EC2 인스턴스는 EC2 모듈을 사용하지 않고 aws_instance 리소스로 생성한다.

- 본 실습을 완료하면 아래와 같은 Architecture의 Cloud 자원이 생성된다.

![](../Reference_docs/images/lab/terraform_lab_arhitecture-Lab05.png)
![](/course-terraform/Reference_docs/images/lab/terraform_lab_arhitecture-Lab05.png)

---

## 5-2. 실습 세부사항

### 5-2-1. `variable.tf`

> 입력 변수는 start 폴더에 미리 정의되어 있다. (추가 작성 필요 없음)

- 새롭게 추가된 변수(3개):
  - vpc_cidr: VPC CIDR
  - public_subnets: 생성할 퍼블릭 서브넷 목록
  - private_subnets: 생성할 프라이빗 서브넷 목록

<br>

### 5-2-2. `main.tf`  

- aws_availability_zones 데이터 소스
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
  - 현재 사용 가능한 가용 영역 정보 가져오기

<br>

- vpc 모듈
  - https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  - cidr(CIDR): 변수 참조
  - azs(가용영역): aws_availability_zones 데이터 소스 참조
  - private_subnets(프라이빗 서브넷): 변수 참조
  - public_subnets(퍼블릭 서브넷): 변수 참조
  - enable_nat_gateway(NAT GW): NAT GW 활성
  - single_nat_gateway(NAT GW): NAT GW 1개만 생성
  - enable_vpn_gateway(VPN GW): 비활성

<br>

- security_group 모듈
  - https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
  - instance_security_group: 인스턴스 보안 그룹
    - http-80 하위 모듈 지정 (https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest/submodules/http-80)
    - VPC: VPC 모듈에서 생성되는 VPC ID 지정
    - CIDR: VPC 모듈에서 생성되는 퍼블릭 서브넷의 CIDR
  - lb_security_group: 로드 벨런서 보안 그룹
    - http-80 하위 모듈 지정 (https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest/submodules/http-80)
    - VPC: VPC 모듈에서 생성되는 VPC ID 지정
    - CIDR: 모든 IP

<br>

- elb 모듈
  - https://registry.terraform.io/modules/terraform-aws-modules/elb/aws/latest
  - Classic Load Balancer
    - internal(내부용): 비활성(외부용)
    - security_groups(보안그룹): lb_security_group 모듈에서 생성되는 리소스 ID
    - subnets(서브넷): vpc 모듈의 퍼블릭 서브넷 
    - number_of_instances(인스턴스 개수): 2
    - instances(인스턴스): instance_a, instance_b
    - listner(리스너): HTTP, 80
    - health_check(헬스 체크): HTTP:80/index.html

<br>

- aws_instance 리소스
  - instance_a / instance_b 둘 다
    - 서브넷: vpc 모듈의 프라이빗 서브넷의 첫번째 인덱스
    - 보안 그룹: instance_security_group 모듈에서 생성되는 리소스 ID

<br>

### 5-2-3. `output.tf`

- Private IP 출력 정의 (추가 작성 필요 없음)
- Instance ID 출력 정의 (추가 작성 필요 없음)
- loadbalancer_dns_name 출력 정의
  - 로드밸런서 DNS 주소 출력

<br>

---

## 5-3. 실습 결과

### 5-3-1. `terraform apply`

```bash
mspmanager:~/environment/course-terraform/05_Module/start $ terraform apply -auto-approve

...
<중략>
...

Plan: 40 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_id_a         = (known after apply)
  + instance_id_b         = (known after apply)
  + instance_private_ip_a = (known after apply)
  + instance_private_ip_b = (known after apply)
  + loadbalancer_dns_name = (known after apply)
module.vpc.aws_vpc.this[0]: Creating...
module.vpc.aws_vpc.this[0]: Still creating... [10s elapsed]
module.vpc.aws_vpc.this[0]: Creation complete after 11s [id=vpc-0f0540af34ac5eb53]
module.vpc.aws_subnet.private[2]: Creating...
module.vpc.aws_default_network_acl.this[0]: Creating...
module.vpc.aws_subnet.public[0]: Creating...
module.vpc.aws_subnet.private[1]: Creating...
module.vpc.aws_subnet.public[3]: Creating...
module.vpc.aws_default_route_table.default[0]: Creating...
module.vpc.aws_default_security_group.this[0]: Creating...
module.vpc.aws_internet_gateway.this[0]: Creating...
module.vpc.aws_route_table.private[0]: Creating...
module.vpc.aws_subnet.public[1]: Creating...
module.vpc.aws_default_route_table.default[0]: Creation complete after 1s [id=rtb-0629d94f91efd68e1]
module.vpc.aws_subnet.private[3]: Creating...
module.vpc.aws_internet_gateway.this[0]: Creation complete after 1s [id=igw-075c7af2bee290a51]
module.vpc.aws_route_table.public[0]: Creating...
module.vpc.aws_route_table.private[0]: Creation complete after 1s [id=rtb-0cb1172c8b2128de1]
module.vpc.aws_subnet.private[0]: Creating...
module.vpc.aws_subnet.private[1]: Creation complete after 1s [id=subnet-0cf9826db2b601322]
module.vpc.aws_subnet.public[2]: Creating...
module.vpc.aws_subnet.public[3]: Creation complete after 1s [id=subnet-0d1ad2d3b1544b41e]
module.vpc.aws_eip.nat[0]: Creating...
module.vpc.aws_subnet.private[2]: Creation complete after 1s [id=subnet-0658839f50f1f16f7]
module.vpc.aws_subnet.public[0]: Creation complete after 1s [id=subnet-0436cc88ed6fdb108]
module.vpc.aws_subnet.public[1]: Creation complete after 1s [id=subnet-0938f80c64dc590ce]
module.lb_security_group.module.sg.aws_security_group.this_name_prefix[0]: Creating...
module.instance_security_group.module.sg.aws_security_group.this_name_prefix[0]: Creating...
module.vpc.aws_default_network_acl.this[0]: Creation complete after 1s [id=acl-0cca5bed276f6a223]
module.vpc.aws_subnet.private[3]: Creation complete after 0s [id=subnet-0002da7794161ecfc]
module.vpc.aws_route_table.public[0]: Creation complete after 0s [id=rtb-03b4b0f83661b7d2d]
module.vpc.aws_route.public_internet_gateway[0]: Creating...
module.vpc.aws_subnet.private[0]: Creation complete after 0s [id=subnet-0a6781ba3e0962c04]
module.vpc.aws_subnet.public[2]: Creation complete after 0s [id=subnet-0fee51fd3e1de07ac]
module.vpc.aws_route_table_association.private[1]: Creating...
module.vpc.aws_eip.nat[0]: Creation complete after 0s [id=eipalloc-0865276990fe350a0]
module.vpc.aws_default_security_group.this[0]: Creation complete after 1s [id=sg-0d611b49cc8f72389]
module.vpc.aws_route_table_association.private[2]: Creating...
module.vpc.aws_route_table_association.private[3]: Creating...
module.vpc.aws_route_table_association.private[0]: Creating...
module.vpc.aws_route_table_association.public[0]: Creating...
module.vpc.aws_route_table_association.public[3]: Creating...
module.vpc.aws_route_table_association.public[2]: Creating...
module.vpc.aws_route_table_association.private[3]: Creation complete after 1s [id=rtbassoc-08f9f7e37c76b0a73]
module.vpc.aws_route_table_association.public[1]: Creating...
module.vpc.aws_route_table_association.public[2]: Creation complete after 1s [id=rtbassoc-0b79f7b704c1b5a19]
module.vpc.aws_route_table_association.private[0]: Creation complete after 1s [id=rtbassoc-064a4ac0a42b32f1a]
module.vpc.aws_nat_gateway.this[0]: Creating...
module.vpc.aws_route.public_internet_gateway[0]: Creation complete after 1s [id=r-rtb-03b4b0f83661b7d2d1080289494]
module.vpc.aws_route_table_association.public[0]: Creation complete after 1s [id=rtbassoc-0f5b1d266fa19f4f8]
module.vpc.aws_route_table_association.private[2]: Creation complete after 1s [id=rtbassoc-02185a4bff996454c]
module.vpc.aws_route_table_association.private[1]: Creation complete after 1s [id=rtbassoc-0f488c358e22e742a]
module.vpc.aws_route_table_association.public[1]: Creation complete after 0s [id=rtbassoc-03ed649d975430897]
module.vpc.aws_route_table_association.public[3]: Creation complete after 1s [id=rtbassoc-0918ffdaaebc72222]
module.instance_security_group.module.sg.aws_security_group.this_name_prefix[0]: Creation complete after 1s [id=sg-0d809eb55aba383fb]
module.instance_security_group.module.sg.aws_security_group_rule.ingress_with_self[0]: Creating...
module.instance_security_group.module.sg.aws_security_group_rule.ingress_rules[0]: Creating...
module.instance_security_group.module.sg.aws_security_group_rule.egress_rules[0]: Creating...
module.lb_security_group.module.sg.aws_security_group.this_name_prefix[0]: Creation complete after 2s [id=sg-0331eeebfa32f5a5d]
module.lb_security_group.module.sg.aws_security_group_rule.egress_rules[0]: Creating...
module.lb_security_group.module.sg.aws_security_group_rule.ingress_with_self[0]: Creating...
module.lb_security_group.module.sg.aws_security_group_rule.ingress_rules[0]: Creating...
module.elb.module.elb.aws_elb.this[0]: Creating...
module.lb_security_group.module.sg.aws_security_group_rule.egress_rules[0]: Creation complete after 0s [id=sgrule-1027603273]
module.instance_security_group.module.sg.aws_security_group_rule.egress_rules[0]: Creation complete after 0s [id=sgrule-219332100]
module.instance_security_group.module.sg.aws_security_group_rule.ingress_with_self[0]: Creation complete after 0s [id=sgrule-3435037761]
module.lb_security_group.module.sg.aws_security_group_rule.ingress_rules[0]: Creation complete after 0s [id=sgrule-1113074774]
module.instance_security_group.module.sg.aws_security_group_rule.ingress_rules[0]: Creation complete after 1s [id=sgrule-1966645930]
module.lb_security_group.module.sg.aws_security_group_rule.ingress_with_self[0]: Creation complete after 1s [id=sgrule-4015092729]
module.elb.module.elb.aws_elb.this[0]: Creation complete after 3s [id=elb-myproject-development]
module.vpc.aws_nat_gateway.this[0]: Still creating... [10s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [20s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [30s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [40s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [50s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m0s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m10s elapsed]
module.vpc.aws_nat_gateway.this[0]: Still creating... [1m20s elapsed]
module.vpc.aws_nat_gateway.this[0]: Creation complete after 1m23s [id=nat-0ebf4dd164b76fa95]
module.vpc.aws_route.private_nat_gateway[0]: Creating...
module.vpc.aws_route.private_nat_gateway[0]: Creation complete after 1s [id=r-rtb-0cb1172c8b2128de11080289494]
aws_instance.instance_a: Creating...
aws_instance.instance_b: Creating...
aws_instance.instance_a: Still creating... [10s elapsed]
aws_instance.instance_b: Still creating... [10s elapsed]
aws_instance.instance_a: Creation complete after 12s [id=i-0726e7efabb058099]
aws_instance.instance_b: Creation complete after 12s [id=i-0ec0b83a14b1718c4]
module.elb.module.elb_attachment.aws_elb_attachment.this[0]: Creating...
module.elb.module.elb_attachment.aws_elb_attachment.this[1]: Creating...
module.elb.module.elb_attachment.aws_elb_attachment.this[0]: Creation complete after 1s [id=elb-myproject-development-20230924045935532300000006]
module.elb.module.elb_attachment.aws_elb_attachment.this[1]: Creation complete after 1s [id=elb-myproject-development-20230924045935651700000007]

Apply complete! Resources: 40 added, 0 changed, 0 destroyed.

Outputs:

instance_id_a = "i-0726e7efabb058099"
instance_id_b = "i-0ec0b83a14b1718c4"
instance_private_ip_a = "10.0.101.88"
instance_private_ip_b = "10.0.102.176"
loadbalancer_dns_name = "elb-myproject-development-586289732.ap-northeast-2.elb.amazonaws.com"
mspmanager:~/environment/course-terraform/05_Module/start $ 
```

<br>

### 5-3-2. `terraform state list`

```bash
mspmanager:~/environment/course-terraform/05_Module/start $ terraform state list
data.aws_ami.ubuntu_linux
data.aws_availability_zones.available
data.cloudinit_config.init
aws_instance.instance_a
aws_instance.instance_b
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
module.vpc.aws_route_table_association.private[2]
module.vpc.aws_route_table_association.private[3]
module.vpc.aws_route_table_association.public[0]
module.vpc.aws_route_table_association.public[1]
module.vpc.aws_route_table_association.public[2]
module.vpc.aws_route_table_association.public[3]
module.vpc.aws_subnet.private[0]
module.vpc.aws_subnet.private[1]
module.vpc.aws_subnet.private[2]
module.vpc.aws_subnet.private[3]
module.vpc.aws_subnet.public[0]
module.vpc.aws_subnet.public[1]
module.vpc.aws_subnet.public[2]
module.vpc.aws_subnet.public[3]
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

### 5-3-3. `terraform destroy`

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
> │ Warning: cleaning up ELB Classic Load Balancer (elb-myproject-development) ENIs: 2 errors occurred:
> │       * detaching EC2 Network Interface (eni-03b2e35974fb79362/eni-attach-069966dd31b824275): AuthFailure: You do not have permission to access the specified resource.
> │       status code: 400, request id: 475dddbe-1fb5-4909-a49e-96db8e87b89d
> │       * detaching EC2 Network Interface (eni-0e08805630f395795/eni-attach-03dcc7e7200ce59ed): AuthFailure: You do not have permission to access the specified resource.
> │       status code: 400, request id: 9de29539-57ee-46d0-910c-0af7de2d3ec4
> │ 
> ╵
> ╷
> │ Warning: EC2 Default Network ACL (acl-0cca5bed276f6a223) not deleted, removing from state
> │ 
> ╵
> ```

<br>

- Module을 활용한 Lab의 경우 다운로드된 provider의 용량이 크기 때문에 이후 실습을 원활하게 진행하기 위해서 `.terraform` 폴더를 삭제해주도록 하자!  

🧲 (COPY)  

```bash
rm -rf ~/environment/course-terraform/05_Module/start/.terraform*
```

---

<br>
<br>

😃 **Lab 5 완료!!!**

<br>

⏩ 다음 실습으로 [이동](../06_Loop_count/README.md)합니다.

<br>
<br>

<center> <a href="../README.md">[목록]</a> </center>
