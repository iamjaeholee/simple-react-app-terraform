resource "aws_docdb_cluster_instance" "squid_instance" {
  count              = 1
  identifier         = "docdb-squid-${count.index}"
  cluster_identifier = aws_docdb_cluster.squid.id
  instance_class     = "db.t3.medium"
}

resource "aws_docdb_cluster" "squid" {
  cluster_identifier              = "docdb-squid"
  master_username                 = "squid"
  master_password                 = "dhdlfskarnt"
  skip_final_snapshot             = true
  db_subnet_group_name            = aws_docdb_subnet_group.squid_subnet_group.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.squid_parameter_group.name
  vpc_security_group_ids          = ["${aws_security_group.squid.id}"]
}

resource "aws_docdb_subnet_group" "squid_subnet_group" {
  name       = "squid-subnet-group"
  subnet_ids = [aws_subnet.squid-publica.id, aws_subnet.squid-publicb.id]

  tags = {
    Name = "My docdb subnet group"
  }
}

resource "aws_docdb_cluster_parameter_group" "squid_parameter_group" {
  family = "docdb4.0"
  name   = "squid-parameter-group"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}
