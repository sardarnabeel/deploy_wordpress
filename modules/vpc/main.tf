#if we want to create Multiple VPC in single aws account we can change region value for diffenct env like prod dev etc
#another way we can use alias in provider.tf to deploy vpc in multiple region

resource "aws_vpc" "main" {
  cidr_block = var.VPC.vpc_cidr_block
  tags = {
    Name = "main-${terraform.workspace}"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.VPC.public_subnet_cidr[0]
  availability_zone = element(data.aws_availability_zones.available.names, 0)

  tags = {
    Name = "PublicSubnet-${terraform.workspace}-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.VPC.public_subnet_cidr[1]
  availability_zone = element(data.aws_availability_zones.available.names, 1)

  tags = {
    Name = "PublicSubnet-${terraform.workspace}-2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.VPC.private_subnet_cidr[0]
  availability_zone = element(data.aws_availability_zones.available.names, 0)

  tags = {
    Name = "PrivateSubnet-${terraform.workspace}-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.VPC.private_subnet_cidr[1]
  availability_zone = element(data.aws_availability_zones.available.names, 1)

  tags = {
    Name = "PrivateSubnet-${terraform.workspace}-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
  Name = "MainIGW-${terraform.workspace}"
}
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
  Name = "PublicRouteTable-${terraform.workspace}"
}
}

resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

##############
#conditionally create the internet Gateway resource based on a boolean value. 
##############

# resource "aws_internet_gateway" "igw" {
#   count = var.VPC.create_internet_gateway ? 1 : 0
#   vpc_id = aws_vpc.main.id
#   tags = {
#     Name = "MainIGW"
#   }
# }


# resource "aws_route_table" "public_route_table" {
#   count = var.VPC.create_internet_gateway ? 1 : 0  
#   vpc_id = aws_vpc.main.id

#   dynamic "route" {
#     for_each = aws_internet_gateway.igw
#     content {
#       cidr_block = "0.0.0.0/0"
#       gateway_id = route.value.id
#     }
#   }

#   tags = {
#     Name = "PublicRouteTable"
#   }
# }

# resource "aws_route_table_association" "public_subnet_association1" {
#   count         = var.VPC.create_internet_gateway ? 1 : 0  # Adjust this according to your logic
#   subnet_id     = aws_subnet.public_subnets[count.index].id
#   route_table_id = aws_route_table.public_route_table[count.index].id
# }

# resource "aws_route_table_association" "public_subnet_association2" {
#   count         = var.VPC.create_internet_gateway ? 1 : 0  # Adjust this according to your logic
#   subnet_id     = aws_subnet.public_subnets[count.index].id
#   route_table_id = aws_route_table.public_route_table[count.index].id
# }




########
#conditionally create the NAT Gateway resource based on a boolean value. 
#########

resource "aws_nat_gateway" "nat_gateway" {
  count = var.VPC.create_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat_eip[count.index].id
  # subnet_id     = aws_subnet.public_subnet_association_1[0].id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
  Name = "NATGateway-${terraform.workspace}"
}
}

resource "aws_eip" "nat_eip" {
  count = var.VPC.create_nat_gateway ? 1 : 0

  domain = "vpc"
  tags = {
  Name = "NATEIP-${terraform.workspace}"
}
}



resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.VPC.create_nat_gateway ? aws_nat_gateway.nat_gateway[0].id : null
  }

  # tags = {
  #   Name = "PrivateRouteTable-${var.VPC.environment}-${count.index}"
  # }
  tags = {
  Name = "PrivateRouteTable-${terraform.workspace}"
}
  
}

resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}