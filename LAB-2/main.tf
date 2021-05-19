provider "aws" {
    region = "us-east-2"

  
}

resource "aws_instance" "web" {
    ami="ami-077e31c4939f6a2f3"
    instance_type="t3.micro"
    vpc_security_group_ids = [ "${aws_security_group.web.id}" ] //always use the ${}
    user_data=<<EOF
#!/bin/bash
yum -y update
yum -y install httpd
MYIP='curl http://169.254.169.254/latest/meta-data/local-ipv4'
echo "<h2>WebServer with PrivateIP: $MYIP</h2><br>Built by Terraform" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF   
     tags={
         Name= "Webserver terraform"
         Owner= "Edwin Maina"

     }   
}

resource "aws_security_group" "web" {
  name        = "WebServer-SG"
  description = "Security Group for my WebServer"

  ingress {
    description = "Allow port HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "WebServer SG by Terraform"
    Owner = "Edwin Maina"
  }
}