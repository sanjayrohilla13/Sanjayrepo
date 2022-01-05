# Pull a container image
resource "docker_image" "nodered_image" {
  name = var.image_in
}