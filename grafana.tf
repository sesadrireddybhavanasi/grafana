#apache-security group
resource "aws_security_group" "grafana" {
  name        = "grafana"
  description = "this is using for securitygroup"
  vpc_id      = "vpc-0ff0fc318b12bf0ae"

  ingress {
    description = "this is inbound rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["43.225.22.66/32"]
  }
  ingress {
    description = "this is inbound rule"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "grafana"
  }
}
#apacheuserdata
data "template_file" "grafanauser" {
  template = file("grafana.sh")

}
# apache instance
resource "aws_instance" "grafana" {
  ami                    = "ami-074dc0a6f6c764218"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0f60f8b79257a51fa"
  vpc_security_group_ids = [aws_security_group.grafana.id]
  key_name               = "seshu"
  user_data              = data.template_file.grafanauser.rendered
  tags = {
    Name = "stage-grafana"
  }
}



