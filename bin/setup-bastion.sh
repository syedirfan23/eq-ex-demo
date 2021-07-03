#!/bin/bash

#install utils
sudo apt --assume-yes install apt-transport-https
sudo apt --assume-yes install software-properties-common
sudo apt --assume-yes install wget

# install jdk8
sudo apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main'
sudo apt-get update
sudo apt --assume-yes install openjdk-8-jdk
sudo update-java-alternatives -a
java -version

#install jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ >> /etc/apt/sources.list'
sudo apt-get --assume-yes update
sudo apt-get --assume-yes install jenkins

sleep 30
sudo sed -i 's/https/http/g' /var/lib/jenkins/hudson.model.UpdateCenter.xml

#Install plugins
cat >> /tmp/plugins.txt << 'END'
email-ext:2.83
momentjs:1.1.1
jquery3-api:3.6.0-1
workflow-aggregator:2.6
script-security:1.77
matrix-auth:2.6.7
token-macro:2.15
font-awesome-api:5.15.3-3
workflow-multibranch:2.26
ant:1.11
scm-api:2.6.4
handlebars:3.0.8
popper-api:1.16.1-2
pam-auth:1.6
github-branch-source:2.11.1
github:1.33.1
git:4.7.2
pipeline-input-step:2.12
workflow-durable-task-step:2.39
gradle:1.36
antisamy-markup-formatter:2.1
snakeyaml-api:1.29.1
docker-commons:1.17
pipeline-maven:3.10.0
pipeline-rest-api:2.19
echarts-api:5.1.2-2
structs:1.23
build-timeout:1.20
h2-api:1.4.199
credentials:2.5
resource-disposer:0.16
workflow-job:2.41
workflow-basic-steps:2.23
ssh-credentials:1.19
ace-editor:1.1
ssh-slaves:1.32.0
github-api:1.123
okhttp-api:3.14.9
authentication-tokens:1.4
pipeline-github-lib:1.0
lockable-resources:2.11
pipeline-graph-analysis:1.11
sshd:3.0.3
jjwt-api:0.11.2-9.c8b45b8bb173
checks-api:1.7.0
bootstrap5-api:5.0.1-2
workflow-api:2.46
git-server:1.9
pipeline-stage-tags-metadata:1.8.5
credentials-binding:1.26
jsch:0.1.55.2
workflow-step-api:2.23
maven-plugin:3.12
pipeline-stage-view:2.19
plain-credentials:1.7
command-launcher:1.6
pipeline-model-api:1.8.5
javadoc:1.6
apache-httpcomponents-client-4-api:4.5.13-1.0
workflow-scm-step:2.13
caffeine-api:2.9.1-23.v51c4e2c879c8
cloudbees-folder:6.15
mailer:1.34
docker-workflow:1.26
jackson2-api:2.12.3
popper2-api:2.5.4-2
jdk-tool:1.5
branch-api:2.6.4
pipeline-stage-step:2.5
trilead-api:1.0.13
pipeline-build-step:2.13
bouncycastle-api:2.20
ldap:2.7
bootstrap4-api:4.6.0-3
matrix-project:1.19
workflow-support:3.8
workflow-cps-global-lib:2.21
pipeline-model-extensions:1.8.5
config-file-provider:3.8.0
junit:1.51
ws-cleanup:0.39
git-client:3.7.2
pipeline-model-definition:1.8.5
durable-task:1.37
plugin-util-api:2.3.0
workflow-cps:2.92
timestamper:1.13
display-url-api:2.3.5
END

wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.10.0/jenkins-plugin-manager-2.10.0.jar -O /tmp/jenkins-plugin-manager.jar
java -jar /tmp/jenkins-plugin-manager.jar --plugin-download-directory /var/lib/jenkins/plugins --plugin-file /tmp/plugins.txt

# install docker
sudo curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sudo chmod +x /tmp/get-docker.sh
sudo /tmp/get-docker.sh
sudo docker run hello-world
sudo usermod -a -G docker jenkins

#start jenkins
sudo systemctl daemon-reload
sudo systemctl restart jenkins
sudo systemctl status jenkins

#install git
sudo apt --assume-yes install dirmngr --install-recommends
sudo apt --assume-yes install git

# #install ansible
sudo apt update
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt --assume-yes install ansible

#generate ssh-key pair and spit out the public key
sudo su syed23irfan
ssh-keygen -q -t rsa -N '' <<< ""$'\n'"y" >/dev/null 2>&1
cat ~/.ssh/id_rsa.pub
