resource "aws_docdb_cluster_instance" "squid_instance" {
  count              = 1
  identifier         = "docdb-squid-${count.index}"
  cluster_identifier = aws_docdb_cluster.squid.id
  instance_class     = "db.t3.medium"
}

resource "aws_docdb_cluster" "squid" {
  cluster_identifier = "docdb-squid"
  availability_zones = ["ap-northeast-2a", "ap-northeast-2b"]
  master_username    = "squid"
  master_password    = "1234"
}
