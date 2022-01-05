# Step for testing import
# 1. spin a container with below command
#     docker run --name sanjay-nodered nodered/node-red
# 2. Uncomment the below code 
#    #Import example
# 3. run the below command in command line
#     terraform import docker_container.nodered_container2 $(docker inspect --format="{{.ID}}" sanjay-nodered)
# 4. verify using terraform state list
#     the output should show the imported resource

#import example
# resource "docker_container" "nodered_container2" {
#   name = "sanjay-nodered"
#   image = docker_image.nodered_image.latest
# }