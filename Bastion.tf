resource "aws_instance" "bastion" {
  ami           = "ami-0c76973fbe0ee100c"
  instance_type = "t3.small"
  tags = {
    Name : "bastion"
  }
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  subnet_id              = aws_subnet.public-a.id
  depends_on             = [module.eks]
  iam_instance_profile   = aws_iam_instance_profile.bastion.name

  user_data = <<EOF
#!/bin/bash

EOF
}

resource "aws_iam_instance_profile" "bastion" {
  name = "bastion-instance-profile"
  role = aws_iam_role.bastion.name
}


resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "bastion-sg"
  vpc_id      = aws_vpc.practice-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "bastion" {
  name = "TF-bastion-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [aws_iam_policy.tf-bastion-policy.arn]

}

resource "aws_iam_policy" "tf-bastion-policy" {
  name = "bastion-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}