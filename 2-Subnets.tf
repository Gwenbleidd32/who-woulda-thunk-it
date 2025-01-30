/*SUBNETS*/

#Public Subnets
resource "aws_subnet" "public-eu-central-1a" {
  vpc_id                  = aws_vpc.app1.id
  cidr_block              = "10.32.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-Frankfurt"
    Service = "application1"
    Owner   = "Paul"
    Planet  = "Atreides"
  }
}
#>>>

resource "aws_subnet" "public-eu-central-1b" {
  vpc_id                  = aws_vpc.app1.id
  cidr_block              = "10.32.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-Frankfurt"
    Service = "application1"
    Owner   = "Paul"
    Planet  = "Atreides"
  }
}
#>>>

resource "aws_subnet" "public-eu-central-1c" {
  vpc_id                  = aws_vpc.app1.id
  cidr_block              = "10.32.3.0/24"
  availability_zone       = "eu-central-1c"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-Frankfurt"
    Service = "application1"
    Owner   = "Paul"
    Planet  = "Atreides"
  }
}
#>>>>>

#Private Subnets
resource "aws_subnet" "private-eu-central-1a" {
  vpc_id            = aws_vpc.app1.id
  cidr_block        = "10.32.11.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name    = "private-Frankfurt"
    Service = "application1"
    Owner   = "Paul"
    Planet  = "Atreides"
  }
}
#>>>

resource "aws_subnet" "private-eu-central-1b" {
  vpc_id            = aws_vpc.app1.id
  cidr_block        = "10.32.12.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name    = "private-Frankfurt"
    Service = "application1"
    Owner   = "Paul"
    Planet  = "Atreides"
  }
}
#>>>

resource "aws_subnet" "private-eu-central-1c" {
  vpc_id            = aws_vpc.app1.id
  cidr_block        = "10.32.13.0/24"
  availability_zone = "eu-central-1c"

  tags = {
    Name    = "private-Frankfurt"
    Service = "application1"
    Owner   = "Paul"
    Planet  = "Atreides"
  }
}
#>>> 