# simple-react-app-terraform

## what's it for
간단한 Next 프론트앤드 & Node 백엔드 어플리케이션
그리고 Terraform으로 작성한 AWS infra

Just launch it

## Prerequisite
### Docker
앱등이는 윈도우를 고려하지 않습니다... ㅈㅅ
[도커 데스크탑](https://www.docker.com/products/docker-desktop) 설치하는 것이 베스트 입니다.

### Terraform
IaC툴로 테라폼을 사용하고 있습니다. 가볍게 패키지 설치할 때는 brew사용하는 것을 선호하는 편입니다..
```bash=
brew install terraform
```

### AWS cli 설치
AWS ECR에 도커 이미지를 푸시할 때 사용합니다.
```bash=
brew install awscli
```

### AWS credentials
AWS cli를 사용하고 Terraform에서도 aws provider를 사용하기 위해서는 credentials가 필수죠
1. 편한방법
env에 크레덴셜을 셋업하면 Terraform과 awscli 둘 다 대응이 가능하여, 편리합니다. ! 
편리한 방법은 다른 사이드 이펙트가 있다는 것이겠죠 ?
```bash=
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION="ap-northeast-2"
```

2. 적절한 방법 (각 서비스 별로 입맛에 맞게 설정)
```bash=
awscli configure
```
```bash=
provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "/Users/tf_user/.aws/creds"
  profile                 = "customprofile"
}
```

## ECS
### 빌드 스크립트 수정
```bash=
#!/bin/bash
IMAGE_NAME=squid-backend
IMAGE_VERSION=$1

# login ECR
aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 565906264822.dkr.ecr.ap-northeast-2.amazonaws.com

# docker build and tag
docker build -t ${IMAGE_NAME} .
docker tag ${IMAGE_NAME}:latest 565906264822.dkr.ecr.ap-northeast-2.amazonaws.com/${IMAGE_NAME}:latest
docker tag ${IMAGE_NAME}:latest 565906264822.dkr.ecr.ap-northeast-2.amazonaws.com/${IMAGE_NAME}:${IMAGE_VERSION}

# docker push
docker push 565906264822.dkr.ecr.ap-northeast-2.amazonaws.com/${IMAGE_NAME}:latest
docker push 565906264822.dkr.ecr.ap-northeast-2.amazonaws.com/${IMAGE_NAME}:${IMAGE_VERSION}
```

빌드 스크립트에 들어가는 account를 자신의 account로 바꿔주세요

### ECR에 레포 만들기
![](https://i.imgur.com/petLsIi.png)

### 도커 이미지 만들어서 푸시 하기
빌드 스크립트를 실행해주세요
```bash=
bash docker-tag-push.sh 0.0.1
```

태그버전은 알아서 적절하게 해주세용

> 이미지가 푸시되면 로컬에도 이미지가 남아있습니다. 실제로 구동시켜서 어플리케이션이 잘 동작하는지 확인하는 것이 좋습니다 ^^ 돌다리도 두들겨보고 건너기 .

도커 이미지 화긴
```bash=
docker images
```
도커 실행하기
```bash=
docker run -d -p port:port 565906264822.dkr.ecr.ap-northeast-2.amazonaws.com/squid-backend
```
도커 실행 리스트 확인하기
```bash=
docker ps
```

![](https://i.imgur.com/kHQsMn6.png)

### 테라폼 수정하기
이제 테라폼 코드에 ECR에 푸시한 도커 이미지 이름을 넣어줄 차례입니다.  
Deploy를 할 때 도커 이미지를 만들어서 버져닝을 해서 푸시하고  
테라폼 코드에서 이미지 버전만 바꿔서 다시 실행하면 디플로이가 완료되니 

### 테라폼 실행하기
```bash=
terraform init
```
프로바이더를 셋팅해줍니다.
```bash=
terraform plan
```
으로 리소스를 먼저 프로비저닝 해줍니다.
```bash=
terraform apply --auto-approve
```
문제가 없다면 올려줍니다.


## Simple Application 설명
### /
작성한 카드를 모두 가져와 fetch해줍니다.
![](https://i.imgur.com/6Wnd8VE.png)

### /editor
카드를 작성할 수 있는 페이지
`assign` 누르면 카드 저장
[EditorJS 사용](https://editorjs.io/)

사진 첨부하면 multer로 S3에 이미지 업로드

저장 후 라우팅 기능 없으니 참고 ....
![](https://i.imgur.com/zzP0X0g.png)


### /[id]
카드 상세페이지를 보는 곳
![](https://i.imgur.com/BgDIcu7.png)


## 비고
### 컨트리뷰션 환영합니다.ㅁ
