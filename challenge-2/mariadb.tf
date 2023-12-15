resource "docker_container" "mariadb" {
  name = "db"
  hostname = "db"
  image = "mariadb:challenge"
  env = ["MYSQL_ROOT_PASSWORD=1234", "MYSQL_DATABASE=simple-website"]
  networks_advanced {
  name = "my_network"
  }
  ports {
    internal = "3306"
    external = "3306"
  }
  volumes {
    container_path = "/var/lib/mysql"
    volume_name = "mariadb-volume"
}
  labels {
    label = "challenge"
    value = "second"
  }
}
