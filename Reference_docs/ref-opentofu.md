# OpenTofu 소개 및 적용 테스트  

### 1. OpenTofu 소개

Terraform, Vault, Packer 등을 개발한 회사인 HashiCorp는 작년 23년 8월 10일 자사의 오픈소스 프로젝트의 라이선스를 모질라 퍼블릭 라이선스(Mozilla Public License v2.0, MPL 2.0)에서 비즈니스 소스 라이선스( Business Source License, BSL 또는 BUSL이라고도 함) v1.1로 변경하겠다고 밝혔으며, 실제 Terraform의 경우 1.5.7 버전 이후의 정식 버전에 BSL 1.1 라이선스가 적용되었다.
(참고: https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license)   

이에 반발하여 나온 프로젝트가 바로 `OpenTofu`(최초 이름은 OpenTF 였다.)이다. 
OpenTofu는 Terraform의 마지막 무료 라이선스 버전인 v1.5.x를 Fork한 오픈소스이며, 현재 LinuxFoundation 산하에 소속되어 있다.

<br>

### 2. OpenTofu 설치

> 본 과정의 실습환경인 Cloud9에 OpenTofu를 설치해보자. 
> Cloud9은 RHEL 계열의 AmazonLinux를 사용하고 있기 때문에 yum 패키지 매니저를 활용할 예정이다.   

(참고: https://opentofu.org/docs/intro/install/)

2-1. opentufu를 설치하기 위한 Repository를 등록한다. 이때 sudo 권한이 필요하다.  

🧲 (COPY)  

```bash
sudo -i
```

```bash
cat >/etc/yum.repos.d/opentofu.repo <<EOF
[opentofu]
name=opentofu
baseurl=https://packages.opentofu.org/opentofu/tofu/rpm_any/rpm_any/\$basearch
repo_gpgcheck=0
gpgcheck=1
enabled=1
gpgkey=https://get.opentofu.org/opentofu.gpg
       https://packages.opentofu.org/opentofu/tofu/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[opentofu-source]
name=opentofu-source
baseurl=https://packages.opentofu.org/opentofu/tofu/rpm_any/rpm_any/SRPMS
repo_gpgcheck=0
gpgcheck=1
enabled=1
gpgkey=https://get.opentofu.org/opentofu.gpg
       https://packages.opentofu.org/opentofu/tofu/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
EOF
```

```bash
exit
```

✔ **(수행코드/결과 예시)**  

```bash
mspmanager:~/environment $ sudo -i
[root@ip-172-31-10-10 ~]# cat >/etc/yum.repos.d/opentofu.repo <<EOF
> [opentofu]
> name=opentofu
> baseurl=https://packages.opentofu.org/opentofu/tofu/rpm_any/rpm_any/\$basearch
> repo_gpgcheck=0
> gpgcheck=1
> enabled=1
> gpgkey=https://get.opentofu.org/opentofu.gpg
>        https://packages.opentofu.org/opentofu/tofu/gpgkey
> sslverify=1
> sslcacert=/etc/pki/tls/certs/ca-bundle.crt
> metadata_expire=300
> 
> [opentofu-source]
> name=opentofu-source
> baseurl=https://packages.opentofu.org/opentofu/tofu/rpm_any/rpm_any/SRPMS
> repo_gpgcheck=0
> gpgcheck=1
> enabled=1
> gpgkey=https://get.opentofu.org/opentofu.gpg
>        https://packages.opentofu.org/opentofu/tofu/gpgkey
> sslverify=1
> sslcacert=/etc/pki/tls/certs/ca-bundle.crt
> metadata_expire=300
> EOF
[root@ip-172-31-10-10 ~]# exit
logout
```

<br>

2-2. yum을 이용하여 Opentufu를 설치한다.  

🧲 (COPY)  

```bash
sudo yum install -y tofu
```

✔ **(수행코드/결과 예시)**  

```bash
mspmanager:~/environment $ sudo yum install -y tofu
opentofu                                                                                                911  B/s | 2.1 kB     00:02    
opentofu-source                                                                                         129  B/s | 296  B     00:02    
Dependencies resolved.
========================================================================================================================================
 Package                       Architecture                    Version                          Repository                         Size
========================================================================================================================================
Installing:
 tofu                          x86_64                          1.6.2-1                          opentofu                           24 M

Transaction Summary
========================================================================================================================================
Install  1 Package

Total download size: 24 M
Installed size: 76 M
Downloading Packages:
tofu-1.6.2-1.x86_64.rpm                                                                                 7.5 MB/s |  24 MB     00:03    
----------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                   7.5 MB/s |  24 MB     00:03     
opentofu                                                                                                3.2 kB/s | 2.2 kB     00:00    
Importing GPG key 0xE5FD9F80:
 Userid     : "OpenTofu (This key is used to sign opentofu providers) <core@opentofu.org>"
 Fingerprint: E3E6 E43D 84CB 852E ADB0 051D 0C0A F313 E5FD 9F80
 From       : https://get.opentofu.org/opentofu.gpg
Key imported successfully
opentofu                                                                                                7.0 kB/s | 3.9 kB     00:00    
Importing GPG key 0x4C61499F:
 Userid     : "https://packagecloud.io/opentofu/tofu (https://packagecloud.io/docs#gpg_signing) <support@packagecloud.io>"
 Fingerprint: F4AF 70F6 6EAC 4337 EEEC C974 07D3 DFCD 4C61 499F
 From       : https://packages.opentofu.org/opentofu/tofu/gpgkey
Key imported successfully
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                1/1 
  Installing       : tofu-1.6.2-1.x86_64                                                                                            1/1 
  Verifying        : tofu-1.6.2-1.x86_64                                                                                            1/1 
========================================================================================================================================
WARNING:
  A newer release of "Amazon Linux" is available.

  Available Versions:

  Version 2023.4.20240401:
    Run the following command to upgrade to 2023.4.20240401:

      dnf upgrade --releasever=2023.4.20240401

    Release notes:
     https://docs.aws.amazon.com/linux/al2023/release-notes/relnotes-2023.4.20240401.html

========================================================================================================================================

Installed:
  tofu-1.6.2-1.x86_64                                                                                                                   

Complete!
```

<br>

2-3. 설치가 잘 되었는지 확인한다.  

🧲 (COPY)  

```bash
tofu --version
```

✔ **(수행코드/결과 예시)**  

```bash
mspmanager:~/environment $ tofu --version
OpenTofu v1.6.2
on linux_amd64
```

<br>

### 3. OpenTofu Migration

> Terraform으로 작성하고, Apply 반영까지 완료된 코드도 OpenTofu로 Migration이 가능하다.  
> 본 과정에선 실습 `Lab07. Terraform 반복문 - for_each 실습`의 코드를 기반으로 Migration을 시도해보자.  

(참고: https://opentofu.org/docs/intro/migration/)

3-1. Lab07 complete 폴더의 terraform 코드를 실행한다.  

🧲 (COPY)  

- 실습 폴더 이동

```bash
cd ~/environment/course-terraform/07_Loop_for_each/complete
```

- Terraform을 통한 자원 생성 실행

```bash
terraform init
```

```bash
terraform apply -auto-approve
```

- Terraform으로 생성된 자원 및 폴더 구성 확인 

```bash
terraform state list
```

```bash
ls -alF
```

✔ **(수행코드/결과 예시)**  

```bash
mspmanager:~/environment/course-terraform/07_Loop_for_each/complete $ terraform state list
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

mspmanager:~/environment/course-terraform/07_Loop_for_each/complete $ ls -alF
total 364
drwxr-xr-x. 4 ec2-user ec2-user  16384 Apr 16 09:22 ./
drwxr-xr-x. 4 ec2-user ec2-user     52 Apr  8 16:21 ../
drwxr-xr-x. 4 ec2-user ec2-user     38 Apr 16 08:53 .terraform/
-rw-r--r--. 1 ec2-user ec2-user   2490 Apr 16 08:53 .terraform.lock.hcl
-rw-r--r--. 1 ec2-user ec2-user   2603 Aug 11  2023 main.tf
drwxr-xr-x. 3 ec2-user ec2-user     22 Apr  8 16:21 modules/
-rw-r--r--. 1 ec2-user ec2-user    589 Aug 11  2023 output.tf
-rw-r--r--. 1 ec2-user ec2-user    187 Apr 16 08:53 provider.tf
-rw-r--r--. 1 ec2-user ec2-user 323942 Apr 16 09:22 terraform.tfstate
-rw-r--r--. 1 ec2-user ec2-user     30 Aug 11  2023 terraform.tfvars
-rw-r--r--. 1 ec2-user ec2-user   1090 Aug 11  2023 variable.tf
```

<br>

3-2. Migration을 하기전 terraform.tfstate 파일을 백업해둔다.  

🧲 (COPY)  

```bash
cp terraform.tfstate terraform.tfstate.bak
```

✔ **(수행코드/결과 예시)**  

```bash
mspmanager:~/environment/course-terraform/07_Loop_for_each/complete $ cp terraform.tfstate terraform.tfstate.bak
mspmanager:~/environment/course-terraform/07_Loop_for_each/complete $ ls -alF
total 680
drwxr-xr-x. 4 ec2-user ec2-user  16384 Apr 17 01:14 ./
drwxr-xr-x. 4 ec2-user ec2-user     52 Apr  8 16:21 ../
drwxr-xr-x. 4 ec2-user ec2-user     38 Apr 16 08:53 .terraform/
-rw-r--r--. 1 ec2-user ec2-user   2490 Apr 16 08:53 .terraform.lock.hcl
-rw-r--r--. 1 ec2-user ec2-user   2603 Aug 11  2023 main.tf
drwxr-xr-x. 3 ec2-user ec2-user     22 Apr  8 16:21 modules/
-rw-r--r--. 1 ec2-user ec2-user    589 Aug 11  2023 output.tf
-rw-r--r--. 1 ec2-user ec2-user    187 Apr 16 08:53 provider.tf
-rw-r--r--. 1 ec2-user ec2-user 323865 Apr 17 01:10 terraform.tfstate
-rw-r--r--. 1 ec2-user ec2-user 323865 Apr 17 01:14 terraform.tfstate.bak
-rw-r--r--. 1 ec2-user ec2-user     30 Aug 11  2023 terraform.tfvars
-rw-r--r--. 1 ec2-user ec2-user   1090 Aug 11  2023 variable.tf
```

<br>

3-3. `tofu init` 명령어로 초기화를 진행한다.  

🧲 (COPY)  

```bash
tofu init
```

✔ **(수행코드/결과 예시)**  

```bash
mspmanager:~/environment/course-terraform/07_Loop_for_each/complete $ tofu init

Initializing the backend...
Initializing modules...

Initializing provider plugins...
- Finding hashicorp/aws versions matching ">= 3.29.0, >= 4.0.0, >= 5.5.0, >= 5.30.0"...
- Finding latest version of hashicorp/cloudinit...
- Installing hashicorp/aws v5.45.0...
- Installed hashicorp/aws v5.45.0 (signed, key ID 0C0AF313E5FD9F80)
- Installing hashicorp/cloudinit v2.3.3...
- Installed hashicorp/cloudinit v2.3.3 (signed, key ID 0C0AF313E5FD9F80)

Providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://opentofu.org/docs/cli/plugins/signing/

OpenTofu has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

OpenTofu has been successfully initialized!

You may now begin working with OpenTofu. Try running "tofu plan" to see
any changes that are required for your infrastructure. All OpenTofu commands
should now work.

If you ever set or change modules or backend configuration for OpenTofu,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

<br>

3-4. .terraform 폴더에 다운로드된 provider 가 terraform 공식 registry가 아닌 opentofu registry 임을 확인 가능하다.  

🧲 (COPY)  

```bash
cd .terraform/providers/
```

```bash
ls -alF
```

```bash
cd ../..
```

✔ **(수행코드/결과 예시)**  

```bash
mspmanager:~/environment/course-terraform/07_Loop_for_each/complete $ cd .terraform/providers/
mspmanager:~/environment/course-terraform/07_Loop_for_each/complete/.terraform/providers $ ls -alF
total 0
drwxr-xr-x. 4 ec2-user ec2-user 64 Apr 17 01:15 ./
drwxr-xr-x. 4 ec2-user ec2-user 38 Apr 16 08:53 ../
drwxr-xr-x. 3 ec2-user ec2-user 23 Apr 17 01:15 registry.opentofu.org/
drwxr-xr-x. 3 ec2-user ec2-user 23 Apr 16 08:53 registry.terraform.io/
mspmanager:~/environment/course-terraform/07_Loop_for_each/complete/.terraform/providers $ cd ../..
mspmanager:~/environment/course-terraform/07_Loop_for_each/complete $ 
```

<br>

3-5. `tofu plan` 혹은 `tofu apply` 명령어로 terraform과 동일하게 수행 가능하다.  

- tofu apply 명령어 수행

🧲 (COPY)  

```bash
tofu apply
```

✔ **(수행코드/결과 예시)**  

```bash
mspmanager:~/environment/course-terraform/07_Loop_for_each/complete $ tofu apply
data.aws_availability_zones.available: Reading...
module.vpc["proj-alpha"].aws_vpc.this[0]: Refreshing state... [id=vpc-0161db72abc661ae6]
module.vpc["proj-beta"].aws_vpc.this[0]: Refreshing state... [id=vpc-0ce773741ea115d61]
data.aws_availability_zones.available: Read complete after 0s [id=ap-northeast-2]
module.vpc["proj-beta"].aws_default_security_group.this[0]: Refreshing state... [id=sg-0c6c83a3077251b27]
module.vpc["proj-alpha"].aws_default_security_group.this[0]: Refreshing state... [id=sg-00242c31ff0cc4df3]
...
<중략>
...
module.elb["proj-alpha"].module.elb_attachment.aws_elb_attachment.this[3]: Refreshing state... [id=elb-proj-alpha-dev-20240417011010392500000012]
module.elb["proj-alpha"].module.elb_attachment.aws_elb_attachment.this[1]: Refreshing state... [id=elb-proj-alpha-dev-20240417011010402600000014]

No changes. Your infrastructure matches the configuration.

OpenTofu has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

instance_ids = {
  "proj-alpha" = [
    "i-047088c8c310ffbc1",
    "i-0ffead7bb905b260b",
    "i-029f9aaa397f128c2",
    "i-07ea748b2c63bd9d0",
  ]
  "proj-beta" = [
    "i-0cce131424610f508",
    "i-0aca33ee10d2d96cf",
  ]
}
instance_private_ips = {
  "proj-alpha" = [
    "10.0.101.223",
    "10.0.102.224",
    "10.0.101.44",
    "10.0.102.231",
  ]
  "proj-beta" = [
    "10.0.101.190",
    "10.0.102.119",
  ]
}
loadbalancer_dns_name = {
  "proj-alpha" = "elb-proj-alpha-dev-1737465206.ap-northeast-2.elb.amazonaws.com"
  "proj-beta" = "elb-proj-beta-test-706548171.ap-northeast-2.elb.amazonaws.com"
}
```

<br>

3-6. tofu apply로 인해 새롭게 생성된 terraform.tfstate 파일을 살펴보자.

- resource 혹은 module 자원의 provider 항목이 아래와 같이 `registry.opentofu.org`로 등록되어 있음을 확인할 수 있다.

```json
"provider": "provider[\"registry.opentofu.org/hashicorp/aws\"]"
```

<br>

3-7. `tofu destroy` 명령어로 생성된 자원을 삭제해보자.

🧲 (COPY)  

```bash
tofu destroy -auto-approve
```

✔ **(수행코드/결과 예시)**  

```bash
mspmanager:~/environment/course-terraform/07_Loop_for_each/complete $ tofu destroy -auto-approve
module.vpc["proj-beta"].aws_vpc.this[0]: Refreshing state... [id=vpc-0ce773741ea115d61]
module.vpc["proj-alpha"].aws_vpc.this[0]: Refreshing state... [id=vpc-0161db72abc661ae6]
data.aws_availability_zones.available: Reading...
data.aws_availability_zones.available: Read complete after 0s [id=ap-northeast-2]
module.vpc["proj-alpha"].aws_default_network_acl.this[0]: Refreshing state... [id=acl-0fb7824a957d8bd7f]
module.vpc["proj-beta"].aws_default_security_group.this[0]: Refreshing state... [id=sg-0c6c83a3077251b27]
...
<중략>
...
module.elb["proj-alpha"].module.elb_attachment.aws_elb_attachment.this[1]: Refreshing state... [id=elb-proj-alpha-dev-20240417011010402600000014]
module.elb["proj-alpha"].module.elb_attachment.aws_elb_attachment.this[2]: Refreshing state... [id=elb-proj-alpha-dev-20240417011010419900000015]
module.elb["proj-beta"].module.elb_attachment.aws_elb_attachment.this[1]: Refreshing state... [id=elb-proj-beta-test-20240417011010400500000013]
module.elb["proj-alpha"].module.elb_attachment.aws_elb_attachment.this[3]: Refreshing state... [id=elb-proj-alpha-dev-20240417011010392500000012]

OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  - destroy

OpenTofu will perform the following actions:

  # module.ec2["proj-alpha"].aws_instance.instance[0] will be destroyed
  - resource "aws_instance" "instance" {
      - ami                                  = "ami-0a775cde0dd898308" -> null
      - arn                                  = "arn:aws:ec2:ap-northeast-2:424610772993:instance/i-047088c8c310ffbc1" -> null
      - associate_public_ip_address          = false -> null
      - availability_zone                    = "ap-northeast-2a" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 2 -> null
  ...
  <중략>
  ...
  # module.lb_security_group["proj-beta"].module.sg.aws_security_group_rule.ingress_with_self[0] will be destroyed
  - resource "aws_security_group_rule" "ingress_with_self" {
      - description            = "Ingress Rule" -> null
      - from_port              = 0 -> null
      - id                     = "sgrule-4165720154" -> null
      - prefix_list_ids        = [] -> null
      - protocol               = "-1" -> null
      - security_group_id      = "sg-01252901df882dbaf" -> null
      - security_group_rule_id = "sgr-0538927b4f836fc2c" -> null
      - self                   = true -> null
      - to_port                = 0 -> null
      - type                   = "ingress" -> null
    }

Plan: 0 to add, 0 to change, 68 to destroy.
...
<중략>
...
module.vpc["proj-beta"].aws_vpc.this[0]: Destruction complete after 1s
module.vpc["proj-alpha"].aws_vpc.this[0]: Destruction complete after 1s

Destroy complete! Resources: 68 destroyed.
```

<br>

> 👉 OpenTofu는 Terraform과 거의 동일한 Command를 갖고 있으며, 기존 Terraform 코드에 대한 migration도 어렵지 않음을 확인할 수 있다.

<br>

😃 **OpenTofu 소개 및 적용 테스트 완료!!!**

<br>
<br>

<center> <a href="../README.md">[목록]</a> </center>
