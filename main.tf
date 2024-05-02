
module "my_vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  public_subnets_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_web_subnets_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  private_db_subnets_cidrs = ["10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]
}


# module "bastion" {
#   source        = "./modules/bastion"
#   ami_id        = "ami-01123b84e2a4fba05"
#   instance_type = "t3.medium"
#   key_name      = "woogiekey"
#   subnet_id     = module.my_vpc.public_subnet_ids[0] // my_vpc 모듈에서 반환된 public_subnets 중 첫 번째 서브넷 사용
#   vpc_id        = module.my_vpc.vpc_id // my_vpc 모듈에서 반환된 VPC ID 사용
#   name          = "bastion"
#   allowed_cidr  = ["0.0.0.0/0"]
#   root_volume_size = 20
# }
# #
#

module "openvpn" {
  source      = "./modules/openvpn"
  ami_id      = "ami-000ea6370ba7c6885"
  key_name    = "woogie"
  subnet_id   = module.my_vpc.public_subnet_ids[0]
  vpc_id      = module.my_vpc.vpc_id
}



module "aurora" {
  source        = "./modules/aurora"
  db_name       = "mydatabase"
  db_user       = "root"
  db_password   = "It12345!"
  vpc_id        = module.my_vpc.vpc_id
  subnet_ids    = module.my_vpc.private_db_subnet_ids
  db_instance_class = "db.t3.medium"
}




#
#
# module "rds" {
#   source = "./modules/rds"
#   allocated_storage    = 20
#   storage_type         = "gp2"
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t2.micro"
#   db_name              = "woogiedb"
#   username             = "root"
#   password             = "It12345!"
#   subnet_ids           = module.my_vpc.private_db_subnet_ids
#   bastion_security_group_id = module.bastion.bastion_host_sg_id
#   tags                 = { Name = "woogieDBInstance" }
#   vpc_id        = module.my_vpc.vpc_id
#   identifier             = "woogiedb"
#
# }
#



module "eks" {
  # eks 모듈에서 사용할 변수 정의
  source          = "./modules/eks-cluster"
  cluster_name    = "woogie-cluster"
  cluster_version = "1.29"
  vpc_id          = module.my_vpc.vpc_id
  private_subnets = module.my_vpc.private_web_subnet_ids
  public_subnets  = module.my_vpc.public_subnet_ids
}


module "ecr" {
  source              = "./modules/ecr"
  repository_name     = "sports"
  image_tag_mutability = "MUTABLE"
  scan_on_push        = true
}
