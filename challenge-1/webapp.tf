resource "kubernetes_service" "webapp-service" {
  metadata {
    name = "webapp-service"
  }
  spec {
   port {
     node_port = 30080
     port = 8080
   }
   type = "NodePort"
  }
}