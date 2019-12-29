#!/bin/bash
yum update -y
yum install -y nmap  nc  jq
curl  -v http://169.254.169.254/latest/dynamic/instance-identity/document
export AWS_DEFAULT_REGION=`curl  -v http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region | tr -d \"`
aws secretsmanager get-secret-value --secret-id ssh_private | jq .SecretString | sed 's/^.*:\\"\(.*\)\\.*/\1/' | base64 -d >  /home/ec2-user/.ssh/id_rsa
chmod 600 /home/ec2-user/.ssh/id_rsa
chown ec2-user.ec2-user  /home/ec2-user/.ssh/id_rsa
