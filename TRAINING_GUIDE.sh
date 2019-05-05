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

# create an SSH key

export SSH_KEY_PASSPHRASE='I-will-be-medieval-on-your-SaaS'
rm -f /home/ec2-user/.ssh/id_rsa
ssh-keygen -q -t rsa -N "${SSH_KEY_PASSPHRASE}" -f /home/ec2-user/.ssh/id_rsa

# configure git

export GITHUB_USER='ThyWoof'
export GITHUB_USER_NAME='Paulo Monteiro'
export GITHUB_USER_EMAIL='pauloesquilo@gmail.com'
export GITHUB_REPO=latam-newr-training

git config --global user.name "${GITHUB_USER_NAME}"
git config --global user.email "${GITHUB_USER_EMAIL}"

# clone the repo

cd ~ && git clone "http://github.com/${GITHUB_USER}/${GITHUB_REPO}"
cd ~/${GITHUB_REPO}
git checkout --track origin/S07-dispatch-service-instrumented

#
# ATTENTION: WE NEED TO CHANGE THE ACTIVE BRANCH HERE
#

# build all services

. env.sh
docker-compose build

# bring the services up

docker-compose up -d

#
# OPEN AWS CONSOLE and make port 8080 public on your EC2 instance
#

# WHEN DONE bring the services down 

docker-compose down
