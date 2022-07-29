resource "aws_vpc" "newvpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames  = true

  tags = {
    Name = "newVpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.newvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "publicsubnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.newvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "privatesubnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.newvpc.id

  tags = {
    Name = "myigw"
  }
}


resource "aws_route_table" "forig" {
  vpc_id = aws_vpc.newvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "igroutetable"
  }
}


resource "aws_route_table_association" "asstopublic" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.forig.id
}


