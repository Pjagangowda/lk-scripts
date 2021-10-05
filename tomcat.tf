resource "aws_security_group" "tomcat" {
  name        = "tomcat"
  description = "Allow tomcat inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description     = "ssh-tomcat from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]

  }
  ingress {
    description     = "ssh-tomcat from VPC"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-tomcat-sg"
  }
}

#user_data
data "template_file" "tomcat" {
  template = file("tomcat.sh")

}
#ec2
resource "aws_instance" "tomcat" {
  ami           = var.ami
  instance_type = var.type
  #iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  key_name               = aws_key_pair.dev.id
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = ["${aws_security_group.tomcat.id}"]
  user_data              = data.template_file.tomcat.rendered
  tags = {
    Name = "${var.envname}-tomcat"
  }
}