resource "kubernetes_service" "squid-frontend" {
  metadata {
    name = "squid-frontend"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-ssl-cert" = "arn:aws:acm:ap-northeast-2:457725217880:certificate/59458a9b-d9d0-49cb-8983-ea21340e7da5"
      "service.beta.kubernetes.io/aws-load-balancer-ssl-ports" ="https"
    }
  }

  spec {
    selector = {
      app = "squid-frontend"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
    }

    port {
      name        = "https"
      port        = 443
      target_port = 80
    }

    type = "NodePort"
  }
}


resource "kubernetes_deployment" "squid-frontend" {
  metadata {
    name = "squid-frontend"
    labels = {
      app = "squid-frontend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "squid-frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "squid-frontend"
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
          image = "457725217880.dkr.ecr.ap-northeast-2.amazonaws.com/squid-frontend:3.9.7"
          name  = "squid-frontend"

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
        }
      }
    }
  }
}
