resource "kubernetes_ingress" "ingress-squid" {
  metadata {
    name = "ingress-squid"
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme"= "internet-facing"
      # "alb.ingress.kubernetes.io/target-type"= "ip"
      "service.beta.kubernetes.io/aws-load-balancer-ssl-cert" = "arn:aws:acm:ap-northeast-2:457725217880:certificate/59458a9b-d9d0-49cb-8983-ea21340e7da5"
      "service.beta.kubernetes.io/aws-load-balancer-ssl-ports" ="https"
      "service.beta.kubernetes.io/aws-load-balancer-backend-protocol"= "http"
      "alb.ingress.kubernetes.io/listen-ports" =  "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/actions.ssl-redirect" = "{\"Type\": \"redirect\", \"RedirectConfig\": { \"Protocol\": \"HTTPS\", \"Port\": \"443\", \"StatusCode\": \"HTTP_301\"}}"
    }
  }

  spec {
    rule {
      host = "squid.com"
      http {
        path {
          backend {
            service_name = "ssl-redirect"
            service_port = "use-annotation" 
          }

          path = "/*"
        }

        path {
          backend {
            service_name = "squid-backend"
            service_port = 6449
          }

          path = "/api/*"
        }


        path {
          backend {
            service_name = "squid-frontend"
            service_port = 80 
          }

          path = "/*"
        }
      }
    }

    rule {
      host = "www.squid.com"
      http {
        path {
          backend {
            service_name = "ssl-redirect"
            service_port = "use-annotation" 
          }

          path = "/*"
        }

        path {
          backend {
            service_name = "squid-backend"
            service_port = 6449
          }

          path = "/api/*"
        }



        path {
          backend {
            service_name = "squid-frontend"
            service_port = 80 
          }

          path = "/*"
        }
      }
    }
  }
}
