module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.26.6"
  cluster_name    = "practice-cluster"
  cluster_version = "1.22"
  vpc_id          = aws_vpc.practice-vpc.id
  subnet_ids = [
    aws_subnet.public-a.id,
    aws_subnet.public-b.id,
    aws_subnet.private-a.id,
    aws_subnet.private-b.id
  ]
  eks_managed_node_groups = {
    default_node_group = {
      min_size       = 2
      max_size       = 5
      desired_size   = 2
      instance_types = ["t3.small"]
    }
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
  cluster_endpoint_private_access = true
  cluster_create_security_group   = false
  cluster_security_group_id       = aws_security_group.bastion.id
  worker_create_security_group    = false
  worker_security_group_id        = aws_security_group.bastion.id

}