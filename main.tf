terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "crowdmind_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "crowdmind-vpc"
  }
}
# 2. Public Subnet (Internet se connect hone wala plot)
resource "aws_subnet" "crowdmind_public_subnet" {
  vpc_id                  = aws_vpc.crowdmind_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "crowdmind-public-subnet"
  }
}

# 3. Private Subnet (Chupa hua safe plot)
resource "aws_subnet" "crowdmind_private_subnet" {
  vpc_id            = aws_vpc.crowdmind_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "crowdmind-private-subnet"
  }
}
# 4. Internet Gateway (Main Gate)
resource "aws_internet_gateway" "crowdmind_igw" {
  vpc_id = aws_vpc.crowdmind_vpc.id

  tags = {
    Name = "crowdmind-igw"
  }
}

# 5. Route Table (Naya Rasta)
resource "aws_route_table" "crowdmind_public_rt" {
  vpc_id = aws_vpc.crowdmind_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Iska matlab pure internet ka rasta
    gateway_id = aws_internet_gateway.crowdmind_igw.id
  }

  tags = {
    Name = "crowdmind-public-rt"
  }
}

# 6. Route Table Association (Public Subnet ko is raste se jodna)
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.crowdmind_public_subnet.id
  route_table_id = aws_route_table.crowdmind_public_rt.id
}

# ==========================================
# 7. SECURITY GROUP (Server ka Guard)
# ==========================================
resource "aws_security_group" "crowdmind_sg" {
  name        = "crowdmind-web-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.crowdmind_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "crowdmind-sg"
  }
}

# ==========================================
# 8. EC2 INSTANCE (CrowdMind AI Server)
# ==========================================
resource "aws_instance" "crowdmind_server" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS Image
  instance_type = "t3.micro"             

  subnet_id              = aws_subnet.crowdmind_public_subnet.id
  vpc_security_group_ids = [aws_security_group.crowdmind_sg.id] # Ab yeh sahi se match karega

  tags = {
    Name = "crowdmind-ai-server"
  }
}