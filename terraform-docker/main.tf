# resource "null_resource" "dockervol" {
#   provisioner "local-exec" {
#     command = "mkdir noderedvol/ || true && chown -R 1000:1000 noderedvol/"
#   }
# }
# removed the dockervol from the docker and created inside the container module
# Pull a container image
# resource "docker_image" "nodered_image" {
#   name = "nodered/node-red:latest"
# }
# use module for pulling docker image
module "nodered_image" {
  source = "./image"
  image_in = var.image["nodered"][terraform.workspace]
}

module "influxdb_image" {
  source = "./image"
  image_in = var.image["influxdb"][terraform.workspace]
}
#generate a random string for docker name
resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  upper   = false
  special = false
}

# Run a container
# resource "docker_container" "nodered_container" {
#   depends_on = [null_resource.dockervol]
#   count = local.container_count
#   name  = join("-", ["nodered", terraform.workspace ,random_string.random[count.index].result])
#   #image = docker_image.nodered_image.latest
#   # replace the image with map variable for deploying different images to different environment
#   #image = lookup(var.image, terraform.workspace)
#   #replace lookup with map keys
#   #image = var.image[terraform.workspace]
#   # use image module to get the image
#   image = module.image.image_out
#   ports {
#     internal = var.int_port
#     external = var.ext_port[terraform.workspace][count.index]
#   }
#   volumes {
#     container_path = "/data"
#     # host_path = "/home/sanjay/Documents/projects/learning-terraform/terraform-docker/noderedvol"
#     # change the absolute path to path reference as hard coding is not a good practice
#     host_path = "${path.cwd}/noderedvol"
#   }
# }

#converted the process to convert in the module 
module "container" {
  source = "./container"
  #depends_on = [null_resource.dockervol]
  # dockervol is moved to container module
  count = local.container_count
  name_in  = join("-", ["nodered", terraform.workspace ,random_string.random[count.index].result])
  image_in = module.nodered_image.image_out
  int_port_in = var.int_port
  ext_port_in = var.ext_port[terraform.workspace][count.index]
  container_path_in = "/data"
}