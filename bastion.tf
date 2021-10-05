resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
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
    Name = "${var.envname}-bastion-sg"
  }
}





#key_pair
resource "aws_key_pair" "dev" {
  key_name   = "dev"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0fnXQU/Kc+QE7OrAOVIx6/RXju86pki8lPBhR8NEHlckkHvmjsIUR2t4Wxjjui2VBFS3tL8iZ+T+SWVVLrLo29Sd1lZjxE3G8div1jEmJ3PYjusWIQ0yIoPxOHsZkBrazT/TIFXhMuiwE9T83Us+z4z2x6HrORUoCH0y1Oiu5wi530vI1Roy3bbCeA0IHjSeLGSA1qZYHBv5aRfqSNoyjjKxzec9qzyvFwvtFgWMxCt++QlHkPjuA+62lln8tZkCoFUQ49wNFN6OcgxYq/TH0/smEkLhQUi7Zb59mJK+sKzeHpbHLHWOyGaiJ51yTHiDCp3sWp/E3EUepnzNnKNd3+jHj5198QadQJTHSsWNlGaymz0jcH4ejIxBNo+TbTIUCK44SpxA+2EgJssddc5XuNv6VVTSMtQe16AVbcBs7ev0RIqGUWbgYou/92GcIlAtS1hir6usAdCGcKgaHdDBs+k/ubI15niem35a6Cb9ZCIh69xkeuwtIBRdbmHac1+8= pjagannadhagowda@LAPTOP-I2JQUQ1P"
}
#user_data
data "template_file" "bastion" {
  template = file("rds.sh")

}

#ec2
resource "aws_instance" "bastion" {
  ami                    = var.ami
  instance_type          = var.type
  key_name               = aws_key_pair.dev.id
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  user_data              = data.template_file.bastion.rendered
  tags = {
    Name = "${var.envname}-bastion"
  }
}