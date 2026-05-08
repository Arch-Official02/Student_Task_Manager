resource "aws_security_group" "app_sg" {
  name = "student-task-manager-sg"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Ec2
resource "aws_instance" "app_server" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.app_sg.name]

  user_data = <<-EOF
              #!/bin/bash

              yum update -y

              amazon-linux-extras install docker -y

              service docker start

              usermod -a -G docker ec2-user

              docker pull ${var.docker_image}

              docker run -d -p 5000:5000 ${var.docker_image}

              EOF

  tags = {
    Name = "student-task-manager"
  }
}