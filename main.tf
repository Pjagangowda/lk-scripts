# vpc creation
resource "aws_vpc" "dev" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.envname
  }
}
#subnets
resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = element(var.pubsubnet, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.envname}-publicsubnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.dev.id
  cidr_block        = element(var.privatesubnet, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.envname}-privatesubnet-${count.index + 1}"
  }
}

resource "aws_subnet" "data" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.dev.id
  cidr_block        = element(var.datasubnet, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.envname}-datasubnet-${count.index + 1}"
  }
}

#igw

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "${var.envname}-igw"
  }
}

#eip
resource "aws_eip" "natgw" {
  vpc = true
  tags = {
    Name = "${var.envname}-eip"
  }
}

#nat pubsubnet
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.envname}-natgw"
  }
}

#route tales
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.envname}-public-route"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "${var.envname}-private-route"
  }
}
resource "aws_route_table" "dataroute" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "${var.envname}-route-data"
  }
}

#associate
resource "aws_route_table_association" "pubassociation" {
  count          = length(var.pubsubnet)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "privateassociation" {
  count          = length(var.privatesubnet)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "dataassociation" {
  count          = length(var.datasubnet)
  subnet_id      = element(aws_subnet.data.*.id, count.index)
  route_table_id = aws_route_table.dataroute.id
}