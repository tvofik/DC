resource "aws_instance" "bastion_host" {
  count                       = var.number_bastion
  ami                         = data.aws_ami.windows.id
  instance_type               = var.instance_type
  subnet_id                   = element(data.aws_subnets.public_subnets.ids, count.index % length(data.aws_subnets.public_subnets.ids))
  key_name                    = var.key_pair
  iam_instance_profile        = var.instance_role
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Bastion-Host"
  }
}

resource "aws_instance" "domain_controllers" {
  count                  = var.number_dc
  ami                    = data.aws_ami.windows.id
  instance_type          = var.instance_type
  subnet_id              = element(data.aws_subnets.private_subnets.ids, count.index % length(data.aws_subnets.private_subnets.ids))
  key_name               = var.key_pair
  iam_instance_profile   = var.instance_role
  vpc_security_group_ids = [aws_security_group.addc-sg.id]

  tags = {
    Name = "DC0${count.index + 1}"
  }
}

resource "aws_security_group" "bastion-sg" {
  name        = "BastionSG"
  description = "BastionSG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = "3389"
    to_port     = "3389"
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
    Name = "Bastion-SG"
  }
}

resource "aws_security_group" "addc-sg" {
  name        = "ADDC-SG"
  description = "ADDC-SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = "49152"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port       = "3389"
    to_port         = "3389"
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }

  ingress {
    from_port   = "445"
    to_port     = "445"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = "123"
    to_port     = "123"
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = "3268"
    to_port     = "3269"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = "636"
    to_port     = "636"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = "135"
    to_port     = "135"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = "53"
    to_port     = "53"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = "53"
    to_port     = "53"
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = "464"
    to_port     = "464"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = "464"
    to_port     = "464"
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = "88"
    to_port     = "88"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = "88"
    to_port     = "88"
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = "389"
    to_port     = "389"
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = "389"
    to_port     = "389"
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "ADDC-SG"
  }
}
