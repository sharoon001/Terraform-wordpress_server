resource "aws_instance" "mysql" {
  ami             = "ami-0c926e1417ec31a1d"
  instance_type   = "t2.micro"
  private_ip = "10.0.2.12"
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.database.id]
  key_name = "Mykeypair"
  
  tags = {
    Name = "mysql"
  }
}
