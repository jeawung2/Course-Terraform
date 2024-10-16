# Terraform 실습 환경 구성 가이드  

ⓘ AWS Cloud9을 사용하여 실습 환경을 구성한다.  

---
- [Terraform 실습 환경 구성 가이드](#terraform-실습-환경-구성-가이드)
    - [1. AWS Default VPC 생성하기](#1-aws-default-vpc-생성하기)
    - [2. AWS Cloud9 실습 환경 구성하기](#2-aws-cloud9-실습-환경-구성하기)
    - [3. Terraform 실습 교재 준비하기](#3-terraform-실습-교재-준비하기)
---

### 1. AWS Default VPC 생성하기

▶ Terraform 실습 환경은 AWS에서 각 Region 마다 기본으로 제공하는 Default VPC(기본 VPC)에 구축할 예정이다. 본 과정에서 수강생에게 제공하는 AWS 계정은 Default VPC가 없는 경우가 있기 때문에, 실습 Region에 Default VPC가 존재하는지 확인하고, 만약 없다면 새로 생성한다.  

1-1. AWS Console에 접속하여 [VPC](https://ap-northeast-2.console.aws.amazon.com/vpc/home?region=ap-northeast-2#vpcs:) 서비스로 이동하고, 좌측의 `Your VPCs` 메뉴를 클릭한다.  

> 실습 Region : `ap-northeast-2 (Seoul)`

![](images/ref/default-vpc-01.png)

<br>

1-2. 우측 VPC 리스트에 Default VPC가 존재하는지 확인한다. 

- Default VPC가 존재하는 경우 : 아래와 같이 Default VPC 항목(우측으로 스크롤 이동하여 확인 가능)이 `Yes`로 되어 있는 VPC가 이미 있다면 [2. AWS Cloud9 실습 환경 구성하기](#2-aws-cloud9-실습-환경-구성하기)로 이동한다.  

![](images/ref/default-vpc-02.png)

- Default VPC가 존재하지 않는 경우 : 아래와 같이 리스트에 VPC가 없거나, VPC는 있지만 Default VPC 항목(우측으로 스크롤 이동하여 확인 가능)이 `No`로 되어 있다면 새로운 Default VPC를 생성해줘야 한다.

![](images/ref/default-vpc-03.png)

<br>

1-3. Your VPC 우측 상단의 `Actions` > `Create default VPC`를 클릭한다.  

![](images/ref/default-vpc-04.png)

<br>

1-4. `Create default VPC` 버튼을 클릭한다.  

![](images/ref/default-vpc-05.png)

<br>

1-5. 성공적으로 vpc가 생성되었다는 문구가 나타나면서, Details > Default VPC 항목에 Yes로 표기되어 있음을 확인할 수 있다.  

![](images/ref/default-vpc-06.png)

<br>

### 2. AWS Cloud9 실습 환경 구성하기  

▶ Cloud9은 클라우드 기반의 IDE(통합 개발 환경)를 제공하며, 실습에 필요한 AWS CLI 도구가 미리 설치되어 있고, 별도 Access Key 등록 작업 없이 AWS IAM을 통해 권한이 자동으로 설정되기 때문에 본 실습에서 활용할 예정이다.  

2-1. AWS Console에서 [Cloud9](https://ap-northeast-2.console.aws.amazon.com/cloud9control/home?region=ap-northeast-2#/) 서비스로 이동한다.

> 실습 Region : `ap-northeast-2 (Seoul)`

![](images/ref/cloud9-00.png)

<br>

2-2. 우측 상단의 `Create environment` 버튼을 클릭한다.  

![](images/ref/cloud9-01.png)

<br>

2-3. Create Environment 화면에서 아래와 같이 입력하고 하단의 `Create` 버튼을 클릭한다.  

>|항목|내용|액션|
>|---|---|---|
>➕ Details > Name|`terraform-environment`|🧲복사 & 📋붙여넣기|
>➕ New EC2 instance > Instance Type|`t3.small`|👆🏻라디오버튼 선택|
>➕ New EC2 instance > Timeout|`1 day`|👆🏻셀렉트박스 선택|
>➕ Network settings > VPC settings > VPC|`{DEFAULT_VPC_ID}`|👆🏻셀렉트박스 선택|
>➕ Network settings > VPC settings > Sunbnet|`ap-northeast-2a` 혹은 `ap-northeast-2c`|👆🏻셀렉트박스 선택|  

![](images/ref/cloud9-02.png)
![](images/ref/cloud9-03.png)
![](images/ref/cloud9-04.png)
![](images/ref/cloud9-05.png)

<br>

2-4. `terraform-environment` 이름의 개발환경이 생성된 것을 확인할 수 있다.  

![](images/ref/cloud9-06.png)

❗❗`terraform-environment` 개발환경이 생성된 후, EC2 > Instances 메뉴로 접속해보면 Instance 하나가 생성된 것을 확인할 수 있다. 해당 Instance는 절대로 <b>삭제하지 않도록 주의</b>하자❗❗ 

![](images/ref/cloud9-11.png)

<br>

2-5. 목록에서 `Open` 링크를 클릭하면 새탭에서 Cloud9 개발환경에 접속된다.  

![](images/ref/cloud9-07.png)

<br>

2-6. Cloud9 화면 구성에 대한 간략한 설명은 아래와 같다.

- File Explorer(화면 좌측) : File과 Folder 구성
- File Contents Editor(Main 화면) : 파일 상세 확인 및 수정
- Terminal Window(화면 하단) : Bash Shell

![](images/ref/cloud9-09.png)

<br>

2-7. Welcome Page 우측에 메인 테마 및 에디터 테마를 변경할 수 있는 옵션이 제공된다. 취향에 맞는 테마를 선택하자. (참고로 본 교재에서는 Flat Light Theme를 사용했다.)  

![](images/ref/cloud9-08.png)

<br>

2-8. 접속한 cloud9에는 aws cli가 설치되어 있고, aws configuration 등록되어 있다. 하단의 Terminal 창에서 명령어를 통해 직접 확인해보자.

> 만약, 터미널 창이 안보이면 상단 메뉴의 `Window` > `New Terminal`를 클릭하여 새 Terminal 창을 Open 할 수 있다.  

- AWS Cli설치 확인

🧲 (COPY)  

```bash
aws --version
```


✔ **(수행코드/결과 예시)**  
```bash
$ aws --version
aws-cli/2.15.32 Python/3.11.8 Linux/6.1.79-99.167.amzn2023.x86_64 exe/x86_64.amzn.2023 prompt/off
```

![](./images/ref/cloud9-10.png)

<br>

- AWS 인증 확인

AWS Cloud9은 현재 AWS에 접속한 사용자의 권한으로 실행된다. 적절한 인증이 되어 있는지 확인한다.

🧲 (COPY)  

```bash
aws sts get-caller-identity
```

✔ **(수행코드/결과 예시)**  
```bash
$ aws sts get-caller-identity
{
    "Account": "123456789012", 
    "UserId": "ABCDEFGHIJKLMNOPQRSTU", 
    "Arn": "arn:aws:iam::123456789012:user/abcdefg"
}
```
<br>

2-9. Terminal 창에서 아래 명령어를 통해 Terraform을 설치하자.

- Terraform cli 설치 (1.5.7버전)

🧲 (COPY)  

```bash
cd ~/environment
```

```bash
wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
```

```bash
unzip ~/environment/terraform_1.5.7_linux_amd64.zip
```

```bash
sudo mv ~/environment/terraform /usr/local/bin
```

✔ **(수행코드/결과 예시)**  
```bash
$ cd ~/environment

$ wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
--2024-04-08 12:32:18--  https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
Resolving releases.hashicorp.com (releases.hashicorp.com)... 54.230.61.31, 54.230.61.117, 54.230.61.88, ...
Connecting to releases.hashicorp.com (releases.hashicorp.com)|54.230.61.31|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 21019880 (20M) [application/zip]
Saving to: ‘terraform_1.5.7_linux_amd64.zip’

terraform_1.5.7_linux_amd64.zip       100%[========================================================================>]  20.05M  82.8MB/s    in 0.2s    

2024-04-08 12:32:19 (82.8 MB/s) - ‘terraform_1.5.7_linux_amd64.zip’ saved [21019880/21019880]

$ ls
README.md  terraform_1.5.7_linux_amd64.zip

$ unzip ~/environment/terraform_1.5.7_linux_amd64.zip 
Archive:  /home/ec2-user/environment/terraform_1.5.7_linux_amd64.zip
  inflating: terraform

$ sudo mv ~/environment/terraform /usr/local/bin
```

<br>

- Terraform 설치 확인

🧲 (COPY)  

```bash
terraform -version
```


✔ **(수행코드/결과 예시)**  
```bash
$ terraform -version
Terraform v1.5.7
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.7.5. You can update by downloading from https://www.terraform.io/downloads.html
```

> 👉 24년 4월 현재 terraform의 최신 버전은 1.7.x 버전이다. 버전 확인시 최신 버전을 다운로드 받으라는 문구가 보이지만, 본 강의의 실습과정에선 마지막 무료 라이선스 버전인 1.5.7 버전을 사용할 예정이니 무시해도 좋다.  

<br>

### 3. Terraform 실습 교재 준비하기  

▶ Terraform 실습 교재와 실습 Code 파일은 강의중 전달하는 Download URL을 통해 다운로드 받은 `course-terraform.zip` 파일을 사용한다. 파일 다운로드 방법 및 실습 코드에 대해 알아보자.  

3-1. 실습용 녹스미팅 채팅창으로 공유된 `<<Download_URL>>`을 활용하여 Cloud9의 Terminal 창에서 아래 명령어를 통해 `course-terraform.zip` 파일을 다운로드 받는다.  

- wget 명령어를 통해 실습 zip 파일 다운로드  

🧲 (COPY)  

```bash
cd ~/environment
```

```bash
wget -O course-terraform.zip <<Download_URL>>
```
❗ `<<Download_URL>>`의 값은 공유받은 url로 수정한다.

✔ **(수행코드/결과 예시)**  
```bash
$ cd ~/environment

$ wget -O course-terraform.zip https://t.ly/fExIQ
--2024-04-10 16:24:40--  https://t.ly/fExIQ
Resolving t.ly (t.ly)... 104.26.13.201, 172.67.75.122, 104.26.12.201, ...
Connecting to t.ly (t.ly)|104.26.13.201|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://terraform-code-download.s3.ap-northeast-2.amazonaws.com/course-terraform.zip?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEPj%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaDmFwLW5vcnRoZWFzdC0yIkgwRgIhAOuHJxojuEj25sUaVl32l%2FPkRHCWLs%2FcDwS9PaTqB%2F%2FWAiEA3XJyR%2BK6dfu9uFJFa0rwomXZV6DCguMgFH59Q2xgZ98qiQMIMRAAGgw0MjQ2MTA3NzI5OTMiDIyBdtSBxDyLt%2F09tyrmAtCK8PvCtZCWN40jMs691u0bJ5wS9UahfAmF1cXzaZyay6EK9pk8zIh7GyfnqH7dQ2%2BdlKGR535wE7UMLUWCvWN1ny8%2BJEfzUNPUqU4vJf7LjyE%2BmBJdG0M46rVZgoE4StPw1T43WmKLSUFVSBiJQZjiKr4%2FPYqWnxbeEluRiwrBW81UxKNZod%2BetYlI%2BdgHnoZaOAn0kGwjf1C%2FaPm9ykq%2BQAr4u%2BmIUAgtWRpdf0GZub41jrZNEt4QcaFgtorvsYiGFvl33fHim1sKZbKzO%2BMxZQ9fOf3WICQ4OcpQy1ZqHmc9r9ZjIYbGaz4EkM42uCW0%2BVvWLfj7u2nUl36HpvTuEM2lN9Ip1P5eDe3a8lcpummKLUoUpMpb4vQWfmwFZn07gINOGm2Qnn9hRtPgkM4AIm8Ck3wuuXnaQ%2FXzBwGm8esEGvUd1oeiVAeE5%2FTSmZYVHm7xDmY2DDIFgsJPKoE4YHLXSVAw5sXasAY6sgLqv5qZorW%2FQasYUt8bGCZqDAyqV%2B3fxywk%2FdoKvWVUJ7adEYKgcM%2BOq4DW3S26fHQ6Dr4L2jbXOSKB6APjnB%2Bj2%2BdxBORGkQAvGLmupaFqrG2x3O4g7ltJU7e6s18PSiwvw4HRoVBEH7p5mu6X38HgmZZNA1hdcbrXUxok%2FNrgg9fROoNkwu3%2FZ7bgC%2BvSRxKc0sQINe%2FnzuaypOysfpDrYHW8AvoTKdeJOv1TTGbO7kP4XhArAXhfvVKa7VKhcs1EAEJhZzCd2LcD7jl3B%2BqHI2IHeOy%2FxKIiBPvDt42xRrzlrvz38nqTkyw7m68G7apxJ13aZ%2B%2FO%2BILTsBYvG%2Fin4eJ8t0gOgoJB79CD1vgfOUMqPuMfTu2C8VLc%2FiUp%2Bb59OIjoHnWqbK3Yqaf7MHjeQPY%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240410T162043Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAWFXGGHAASJDRYJT7%2F20240410%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=3260e80161c0c2a1b399d1fbb55e630fed0ea69f66f3aaf5b4c9c27bc7f17d5c [following]
--2024-04-10 16:24:41--  https://terraform-code-download.s3.ap-northeast-2.amazonaws.com/course-terraform.zip?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEPj%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaDmFwLW5vcnRoZWFzdC0yIkgwRgIhAOuHJxojuEj25sUaVl32l%2FPkRHCWLs%2FcDwS9PaTqB%2F%2FWAiEA3XJyR%2BK6dfu9uFJFa0rwomXZV6DCguMgFH59Q2xgZ98qiQMIMRAAGgw0MjQ2MTA3NzI5OTMiDIyBdtSBxDyLt%2F09tyrmAtCK8PvCtZCWN40jMs691u0bJ5wS9UahfAmF1cXzaZyay6EK9pk8zIh7GyfnqH7dQ2%2BdlKGR535wE7UMLUWCvWN1ny8%2BJEfzUNPUqU4vJf7LjyE%2BmBJdG0M46rVZgoE4StPw1T43WmKLSUFVSBiJQZjiKr4%2FPYqWnxbeEluRiwrBW81UxKNZod%2BetYlI%2BdgHnoZaOAn0kGwjf1C%2FaPm9ykq%2BQAr4u%2BmIUAgtWRpdf0GZub41jrZNEt4QcaFgtorvsYiGFvl33fHim1sKZbKzO%2BMxZQ9fOf3WICQ4OcpQy1ZqHmc9r9ZjIYbGaz4EkM42uCW0%2BVvWLfj7u2nUl36HpvTuEM2lN9Ip1P5eDe3a8lcpummKLUoUpMpb4vQWfmwFZn07gINOGm2Qnn9hRtPgkM4AIm8Ck3wuuXnaQ%2FXzBwGm8esEGvUd1oeiVAeE5%2FTSmZYVHm7xDmY2DDIFgsJPKoE4YHLXSVAw5sXasAY6sgLqv5qZorW%2FQasYUt8bGCZqDAyqV%2B3fxywk%2FdoKvWVUJ7adEYKgcM%2BOq4DW3S26fHQ6Dr4L2jbXOSKB6APjnB%2Bj2%2BdxBORGkQAvGLmupaFqrG2x3O4g7ltJU7e6s18PSiwvw4HRoVBEH7p5mu6X38HgmZZNA1hdcbrXUxok%2FNrgg9fROoNkwu3%2FZ7bgC%2BvSRxKc0sQINe%2FnzuaypOysfpDrYHW8AvoTKdeJOv1TTGbO7kP4XhArAXhfvVKa7VKhcs1EAEJhZzCd2LcD7jl3B%2BqHI2IHeOy%2FxKIiBPvDt42xRrzlrvz38nqTkyw7m68G7apxJ13aZ%2B%2FO%2BILTsBYvG%2Fin4eJ8t0gOgoJB79CD1vgfOUMqPuMfTu2C8VLc%2FiUp%2Bb59OIjoHnWqbK3Yqaf7MHjeQPY%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240410T162043Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAWFXGGHAASJDRYJT7%2F20240410%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=3260e80161c0c2a1b399d1fbb55e630fed0ea69f66f3aaf5b4c9c27bc7f17d5c
Resolving terraform-code-download.s3.ap-northeast-2.amazonaws.com (terraform-code-download.s3.ap-northeast-2.amazonaws.com)... 52.219.56.132, 52.219.206.30, 52.219.58.15, ...
Connecting to terraform-code-download.s3.ap-northeast-2.amazonaws.com (terraform-code-download.s3.ap-northeast-2.amazonaws.com)|52.219.56.132|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 29854452 (28M) [application/zip]
Saving to: ‘course-terraform.zip’

course-terraform.zip          100%[=================================================>]  28.47M   116MB/s    in 0.2s    

2024-04-10 16:24:41 (116 MB/s) - ‘course-terraform.zip’ saved [29854452/29854452]

```

<br>

- 다운로드 완료된 파일 확인

![](./images/ref/download-01.png)

<br>

3-2. 하단 Terminal에 아래 명령어를 입력하여 업로드된 zip 파일의 압축을 풀어준다.

🧲 (COPY)  

```bash
unzip course-terraform.zip
```

✔ **(수행코드/결과 예시)**  
```bash
mspuser:~/environment $ unzip course-terraform.zip 
Archive:  course-terraform.zip
   creating: course-terraform/01_Cloud_Resource_/
   creating: course-terraform/01_Cloud_Resource/complete/
 extracting: course-terraform/01_Cloud_Resource/complete/index.html  
  inflating: course-terraform/01_Cloud_Resource/complete/main.tf  
  inflating: course-terraform/01_Cloud_Resource/complete/provider.tf  
  inflating: course-terraform/01_Cloud_Resource/README.md
   ...
   (생략)
   ...
  inflating: course-terraform/README.md  
mspuser:~/environment $
```

<br>

3-3. 압축을 풀어주면 `course-terraform` 폴더를 확인할 수 있다. 안에는 아래 그림과 같은 디렉토리 구조를 갖는 총 7가지 실습 Lab이 포함되어 있다. 각 실습 디렉토리내 폴더 및 파일의 상세 설명은 아래와 같다.  

![](./images/ref/lab-01.png)

<br>

3-4. 각 실습 Lab에는 해당 실습의 목표와 세부 사항을 확인할 수 있는 `README.md` Markdown 문서가 제공된다. Cloud9에서 MD 파일을 코드 형식이 아닌 HTML 방식으로 열기 위해서는 아래 스샷과 같이 `Preview` 기능을 활용하면 된다.  

![](./images/ref/lab-02.png)

> 👉 듀얼 모니터를 활용하고 있는 경우, Preview 화면의 새창으로 열기 버튼을 클릭하면 편하게 실습을 진행할 수 있다.   

<br>

3-5. 실습 Lab 수행 방법의 상세 가이드는 아래와 같다.

3-5-1. 하단 Terminal에서 cd 명령어로 실습 lab 디렉토리의 start 디렉토리로 이동한다.

예시) "Lab3. Terraform 변수 및 값 활용" 실습을 진행하는 경우  

🧲 (COPY)  
```bash
cd ~/environment/course-terraform/{Lab_Directory}/start
```

✔ **(수행코드/결과 예시)**  
```bash
mspuser:~/environment $ cd ~/environment/course-terraform/03_Variable_and_Value/start
mspuser:~/environment/course-terraform/03_Variable_and_Value/start $ 
```

<br>

3-5-2. `README.md` 파일의 실습 목표 및 실습 세부사항 확인한다.  

![](./images/ref/lab-03.png)

<br>

3-5-3. start 폴더에서 실습 코드를 작성 및 수정한다.  

![](./images/ref/lab-04.png)

<br>

3-5-4. start 폴더의 코드 작성 및 수정이 완료되면, 하단 Terminal에서 terraform 명령어를 순차적으로 수행한다.  

🧲 (COPY)  
```bash
terraform init
```
```bash
terraform plan
```
```bash
terraform apply -auto-approve
```

✔ **(수행코드/결과 예시)**  
![](./images/ref/lab-05.png)
![](./images/ref/lab-06.png)
![](./images/ref/lab-07.png)

<br>

3-5-5. start 폴더에서 실습 코드 작성 및 수정시 `complete 폴더`의 실습 완성 코드를 참고할 수 있다.  

❗실습 진행이 어려운 경우 우선 complete 폴더의 완성 코드를 참고하고, 만약에 complete 폴더의 완성 코드가 잘 이해되지 않는 경우에는 실습 지원 녹스미팅 채팅창에 문의하자❗

<br>

3-5-6. 각 실습 Lab 종료 후 반드시 terraform destroy 명령어를 실행하여 생성된 자원을 모두 정리한다.  

🧲 (COPY)  
```bash
terraform destroy -auto-approve
```

✔ **(수행코드/결과 예시)**  
![](./images/ref/lab-08.png)

<h5>❗❗terraform destroy를 통한 자원 정리를 하지 않는 경우 이후 실습에서 aws resource limit으로 인해 에러가 발생될 수 있다. destroy를 잊지 말고 진행하자❗❗</h5>

<br>

😃 **Terraform 실습 환경 구성 및 준비 완료!!!**

<br>
<br>

<center> <a href="../README.md">[목록]</a> </center>
