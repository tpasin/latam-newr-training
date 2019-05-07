#!/bin/sh
#
# AUTHOR: Paulo Monteiro @ New Relic - 2019-04
#

#
# THESE ARE GUIDELINES FOR A LIVE TRAINING SESSION. DON'T EXECUTE IT DIRECTLY
#

exit 1

#
# PART 1 - CONFIGURE, LAUNCH, AND MONITOR AN EC2 INSTANCE
#

# first things first

sudo yum update -y

#
# DON'T FORGET TO CREATE YOUR .env from env.template
#

# setup some variables

export YOUR_NAME='Winston Wolfe'
export YOUR_COMPANY_NAME='Marsellus Wallace Inc.'
export NEW_RELIC_LICENSE_KEY=''

# install the NR Infra agent

echo "\
license_key: ${NEW_RELIC_LICENSE_KEY}
custom_attributes:
    student: ${YOUR_NAME}
    company: ${YOUR_COMPANY_NAME}
" | sudo tee -a /etc/newrelic-infra.yml
sudo curl -sLo /etc/yum.repos.d/newrelic-infra.repo \
  https://download.newrelic.com/infrastructure_agent/linux/yum/el/6/x86_64/newrelic-infra.repo
sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
sudo yum install newrelic-infra -y

# install docker-compose

curl -sLo docker-compose "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)"
chmod +x docker-compose
sudo mv docker-compose /usr/local/bin

# install git / docker

sudo yum install git docker-io -y
sudo service docker start
sudo usermod -aG docker ec2-user

#
# ATTENTION: NEED TO LOGOUT / LOGIN SO ABOVE GROUP CHANGES TAKE EFFECT
#

exit

#
# PART 2 - CLONE, BUILD, DEPLOY THE APPLICATION
#

# create an SSH key

export SSH_KEY_PASSPHRASE='I-will-be-medieval-on-your-SaaS'
rm -f /home/ec2-user/.ssh/id_rsa
ssh-keygen -q -t rsa -N "${SSH_KEY_PASSPHRASE}" -f /home/ec2-user/.ssh/id_rsa

# configure git

export GITHUB_USER='ThyWoof'
export GITHUB_USER_NAME='Winston Wolfe'
export GITHUB_USER_EMAIL='Winston.Wolfe@marsellus.inc.com'
export GITHUB_REPO=latam-newr-training

git config --global user.name "${GITHUB_USER_NAME}"
git config --global user.email "${GITHUB_USER_EMAIL}"

# clone the repo

cd ~ && git clone "http://github.com/${GITHUB_USER}/${GITHUB_REPO}"
cd ~/${GITHUB_REPO}

#
# ATTENTION: WE NEED TO CHANGE THE ACTIVE BRANCH HERE
#

git checkout --track origin/S09-kubernetes-setup

# build all services

docker-compose build

# bring the services up

docker-compose up -d

#
# OPEN AWS CONSOLE and make port 8888 public on your EC2 instance
#

# WHEN DONE bring the services down 

docker-compose down

#
# PART 3 - Kubernetes setup
#

# publish your fully instrumented images
cd ~/${GITHUB_REPO}
docker login
docker-compose build # just in case :-)
docker-compose push

# source the variables

cd ~/${GITHUB_REPO}
. env.sh

# install kubectl

curl -sLO https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin

# install heptio-authenticator-aws

curl -sLo heptio-authenticator-aws https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_linux_amd64
chmod +x heptio-authenticator-aws
sudo mv heptio-authenticator-aws /usr/local/bin

# configure the AWS cli

export AWS_REGION='us-west-2'

mkdir ~/.aws
printf "[default]\noutput = json\nregion = ${AWS_REGION}\n" > ~/.aws/config
aws configure

# install eksctl

curl -sL "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# create the basic EKS cluster (when done consider saving ~/.kube/config to a safe place)

eksctl create cluster --region=${AWS_REGION} --name=${CLUSTER_NAME}

# check if everything is sound

kubectl get pods --all-namespaces --no-headers -o custom-columns=":metadata.name,:metadata.namespace"

# deploy the New Relic agents

cd ~/${GITHUB_REPO}/_infra
./k8-newrelic.sh -c
