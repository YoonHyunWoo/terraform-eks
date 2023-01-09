#!/bin/bash

# set time zone Asia/Seoul

rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# enable password login to bastion

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd 
ehco 'password' | passwd --stdin ec2-user

# install kubectl

curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin


# install eksctl

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# install docker

yum -y install docker
usermod -aG docker ec2-user
systemctl restart docker 
systemctl enable docker

# update kubeconfig

aws eks update-kubeconfig --name practice-cluster --region ap-northeast-2