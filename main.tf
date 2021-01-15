provider "aws" {
  region = "us-east-2"
  profile = "dev"
}

resource "aws_instance" "mochacat-dev-tf-2021-01" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${8080}" &
              EOF

  tags = {
    Name = "mochacat-dev-tf-2021-01"
  }
}

resource "aws_security_group" "instance" {
  name = "mochacat-terraform-example-instance"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value       = aws_instance.mochacat-dev-tf-2020-01.public_ip
  description = "The public IP of the web server"
}
