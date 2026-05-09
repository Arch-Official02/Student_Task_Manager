#!/bin/bash
yum update -y

# -------------------
# INSTALL DOCKER
# -------------------
yum install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Pull and run app
docker pull archofficial97/student-task-manager:v1.0.0

docker run -d -p 5000:5000 \
  --restart always \
  --name app \
  archofficial97/student-task-manager:v1.0.0


# -------------------
# CLOUDWATCH AGENT
# -------------------
yum install -y amazon-cloudwatch-agent

mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/

cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/devops/ec2-system-logs",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/secure",
            "log_group_name": "/devops/ec2-security-logs",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
-s