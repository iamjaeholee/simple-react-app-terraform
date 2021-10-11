resource "kubernetes_service" "squid-backend" {
  metadata {
    name = "squid-backend"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-ssl-cert" = "arn:aws:acm:ap-northeast-2:457725217880:certificate/59458a9b-d9d0-49cb-8983-ea21340e7da5"
      "service.beta.kubernetes.io/aws-load-balancer-ssl-ports" ="https"
    }
  }
  spec {
    selector = {
      app = "squid-backend"
    }

     port {
      name        = "http"
      port        = 6449
      target_port = 6449
    }

     port {
      name        = "https"
      port        = 443
      target_port = 6449
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "squid-backend" {
  metadata {
    name = "squid-backend"
    labels = {
      app = "squid-backend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "squid-backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "squid-backend"
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
          image = "457725217880.dkr.ecr.ap-northeast-2.amazonaws.com/squid-backend:1.2.6"
          name  = "squid-backend"

          env {
            name  = "DB_DATABASE"
            value = "squid"
          }
          env {
            name  = "DB_HOST"
            value = "mysql"
          }
          env {
            name  = "DB_PORT"
            value = "3306"
          }
          env {
            name  = "DB_USER"
            value = "anton"
          }
          env {
            name  = "DB_PASSWORD"
            value = "password"
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "256Mi"
            }

            requests {
              cpu    = "250m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}
