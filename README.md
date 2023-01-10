# EKS Template for practice

Kubernetes on EKS를 연습하기 위한 템플릿입니다.  https://github.com/YoonHyunWoo/terraform-eks에 새로 커밋될 시 Terraform job이 실행됩니다. 혹은 terraform cloud console에서 직접 트리거할 수도 있습니다. 아래와 같은 리소스가 프로비저닝 됩니다.

# VPC

| name  | practice-vpc |
| cidr  | 10.0.0.0/16 |
| public subnet | [10.0.0.0/24, 10.0.1.0/24] |
| private subnet | [10.0.2.0/24, 10.0.3.0/24] |
| nat gateway | one |
| public route table | one |
| private route table  | one |
| enable_dns_hostnames | true |
| enable_dns_support  | true |

# EC2

EKS Control Plane입니다.

| name | bastion |
| --- | --- |
| AMI | amazon linux 2 |
| install packages | kubectl, eksctl, docker |

# EKS

Security group에 10.0.0.0/16 ip를 source로 필요한 security group rule을 add해줍니다. 스펙은 다음과 같습니다.

| cluster name | practice-cluster |
| --- | --- |
| cluster version | 1.22 |
| ng(node group) desired size | 2 |
| ng min size | 2 |
| ng max size | 5 |
| ng instance type | t3.small |
