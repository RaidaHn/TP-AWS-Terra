module "network" {
  source = "./modules/network"

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "routing_public" {
  source = "./modules/routing-public"

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids

  igw_name      = "igw-main"
  public_rt_name = "rt-public"
}

module "nat" {
  source = "./modules/nat"

  public_subnet_id = values(module.network.public_subnet_ids)[0]
  nat_name         = "nat-main"
}

module "routing_private" {
  source = "./modules/routing-private"

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  nat_gw_id          = module.nat.nat_gw_id

  private_rt_name = "rt-private"
}

module "security_groups" {
  source = "./modules/security-groups"

  vpc_id       = module.network.vpc_id
  name_prefix  = "tp1"
  alb_ingress_cidrs = ["0.0.0.0/0"]  # tu peux restreindre plus tard
  alb_ingress_ports = [80, 443]

  web_ingress_port           = 80
  enable_web_https_from_alb  = false

  tags = {
    Project = "TP1"
    Env     = "lab"
  }
}

module "alb" {
  source = "./modules/alb"

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  sg_alb_id         = module.security_groups.sg_alb_id

  name_prefix       = "tp1"
  alb_port          = 80
  target_port       = 80
  health_check_path = "/"

  tags = {
    Project = "TP1"
    Env     = "lab"
  }
}

module "compute" {
  source = "./modules/compute-ec2"

  private_subnet_ids = module.network.private_subnet_ids
  sg_web_id          = module.security_groups.sg_web_id
  target_group_arn   = module.alb.target_group_arn

  ami_id        = "ami-0c02fb55956c7d316" # Amazon Linux 2 us-east-1 (à vérifier si besoin)
  instance_type = "t3.micro"

  name_prefix = "tp1"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from $(hostname) et Matt le BOSS" > /var/www/html/index.html
              EOF

  tags = {
    Project = "TP1"
    Env     = "lab"
  }
}