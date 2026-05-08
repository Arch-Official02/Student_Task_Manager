#!/bin/bash

# update system
yum update -y

# install docker
yum install -y docker

# start docker
systemctl start docker
systemctl enable docker

# allow ec2-user to use docker
usermod -aG docker ec2-user

# pull your app image (CHANGE THIS)
docker pull archofficial97/student-task-manager:latest

# run container
docker run -d -p 5000:5000 archofficial97/student-task-manager:latest