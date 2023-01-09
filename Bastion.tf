resource "aws_instance" "Bastion" {
  ami           = "ami-0c76973fbe0ee100c"
  instance_type = "t3.small"
  tags = {
    Name : "Bastion"
  }
  vpc_security_group_ids = ["${aws_security_group.Bastion.id}"]
  subnet_id              = aws_subnet.public-a.id
  depends_on             = [module.eks]
}

resource "aws_security_group" "Bastion" {
  name        = "Bastion-sg"
  description = "Bastion-sg"
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
  name = "TF-Bastion-Role"

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

  managed_policy_arns = [aws_iam_policy.TF-Bastion-Policy.arn]

}

resource "aws_iam_policy" "TF-Bastion-Policy" {
  name = "Bastion-Policy"

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