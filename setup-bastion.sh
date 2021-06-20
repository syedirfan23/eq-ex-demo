#!/bin/bash

# install jdk11
sudo apt update
sudo apt install openjdk-11-jdk
java -version

#install jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get --assume-yes update
sudo apt-get --assume-yes install jenkins

#start jenkins
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl status jenkins

#install ansible
sudo apt update
sudo apt --assume-yes install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt --assume-yes install ansible