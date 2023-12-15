resource "docker_container" "php-httpd" {
  name = "webserver"
  hostname = "php-httpd"
  image = "php-httpd:challenge"
  networks_advanced {
  name = "my_network"
  }
  ports {
    internal = "80"
    external = "80"
  }
  volumes {
    container_path = "/var/www/html"
    host_path = "/root/code/terraform-challenges/challenge2/lamp_stack/website_content/"
}
  labels {
    label = "challenge"
    value = "second"
  }
}
#resource "docker_network" "my_network" {
#  name = "my_network"
#}