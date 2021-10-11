resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysql"
  }
  spec {
    selector = {
      app = "mysql"
    }

    port {
      port        = 3306
      target_port = 3306
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "mysql" {
  metadata {
    name = "mysql"
    labels = {
      app = "mysql"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }
      
      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key = "node"
                  operator = "In"
                  values = ["prod"]
                }
             }
            }
          }
        }
        container {
          image = "457725217880.dkr.ecr.ap-northeast-2.amazonaws.com/squid-mysql:0.0.5"
          name  = "mysql"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }

            requests {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          volume_mount {
            mount_path = "/var/lib/mysql"
            name = "mysql"
            read_only = false
          }

          liveness_probe {
            tcp_socket {
              port = "3306"
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

          # lifecycle {
          #   post_start {
          #     exec {
          #       command = ["sh", "-c", "sleep 120;mysql -uroot -ppassword < ./all-databases.sql; mysql -uroot < ./create_user.sql"]
          #     }
          #   }
          # }
        }

        volume {
          name = "mysql"
          aws_elastic_block_store {
            volume_id = aws_ebs_volume.mysql.id
          }
        }
      }
    }
  }
}