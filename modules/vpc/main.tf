
locals {
  cluster_name = "woogie-cluster"
}



# VPC 생성
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "woogie-vpc"
  }
}

# 퍼블릭 서브넷 생성
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "woogie-public-subnet-${count.index == 0 ? "a" : "c"}"
    "kubernetes.io/role/elb" = "1"
  }
}

# 웹용 프라이빗 서브넷 생성
resource "aws_subnet" "private_web" {
  count             = length(var.private_web_subnets_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_web_subnets_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "woogie-private-subnet-web-${count.index == 0 ? "a" : "c"}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "karpenter.sh/discovery/${local.cluster_name}" = local.cluster_name
  }
}

# 데이터베이스용 프라이빗 서브넷 생성
resource "aws_subnet" "private_db" {
  count             = length(var.private_db_subnets_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_db_subnets_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "woogie-private-subnet-db-${count.index == 0 ? "a" : "c"}"
    // 데이터베이스 서브넷에 필요한 추가 태그가 있다면 여기에 포함시킵니다.
  }
}



# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "woogie-igw"
  }
}

# 퍼블릭 라우트 테이블 생성 및 인터넷 게이트웨이 연결
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "woogie-public-rtb"
  }
}

# 퍼블릭 라우트 테이블 연결
resource "aws_route_table_association" "public_assoc" {
  for_each    = { for idx, subnet in aws_subnet.public : idx => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT 게이트웨이용 EIP 생성
resource "aws_eip" "nat" {
  vpc = true
}

# 프라이빗 서브넷을 위한 NAT 게이트웨이 생성
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "woogie-nat-gateway"
  }
}

# 프라이빗 라우트 테이블 생성 및 NAT 게이트웨이 연결
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "woogie-private-rtb"
  }
}

# 프라이빗 서브넷에 라우트 테이블 연결
resource "aws_route_table_association" "private_web_assoc" {
  for_each       = { for idx, subnet in aws_subnet.private_web : idx => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_assoc" {
  for_each       = { for idx, subnet in aws_subnet.private_db : idx => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
