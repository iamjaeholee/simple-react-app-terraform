resource "aws_ebs_volume" "mysql" {
  availability_zone = "ap-northeast-2a"
  size              = 100

  tags = {
    Name = "mysql"
  }
}
