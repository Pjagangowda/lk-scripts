resource "aws_security_group" "elk" {
  name        = "elk"
  description = "Allow elk inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description     = "ssh-elk from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]

  }
  ingress {
    description     = "ssh-elk from VPC"
    from_port       = 5601
    to_port         = 5601
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]

  }
   ingress {
    description     = "ssh-elk from VPC"
    from_port       = 9200
    to_port         = 9200
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
    Name = "${var.envname}-elk-sg"
  }
}

#user_data
data "template_file" "elk" {
  template = file("elk.sh")

}
#ec2
resource "aws_instance" "elk" {
  ami           = var.ami
  instance_type = var.type
  #iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  key_name               = aws_key_pair.dev.id
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = ["${aws_security_group.elk.id}"]
  user_data              = data.template_file.elk.rendered
  tags = {
    Name = "${var.envname}-elk"
  }
}