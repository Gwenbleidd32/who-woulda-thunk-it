# this  makes  vpc.id which is aws_vpc.app1.id
resource "aws_vpc" "app1" {
  cidr_block = "10.32.0.0/16"

  tags = {
    Name = "german"
    Service = "causway"
    Owner = "cahir"
    Planet = "arrakis"
  }
}
#>>>