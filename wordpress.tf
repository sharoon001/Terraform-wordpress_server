
resource "aws_instance" "wordpress" {
  ami             = "ami-08d4ac5b634553e16"
  instance_type   = "t2.micro"
  private_ip = "10.0.1.7"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.webserver.id]
  associate_public_ip_address = true
  key_name = "Mykeypair"
  user_data = file("./user_data.sh")

  tags = {
    Name = "wordpress"
  }
}