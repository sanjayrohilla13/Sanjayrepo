# #define a variable for defining the enviornment
# variable "env" {
#   type        = string
#   description = "The enviornment for deployment"
#   default     = "dev"
# }
# use the terraform.workspace for defining the environment for deploying resources

variable "image" {
  type        = map(any)
  description = "The list of docker images for various enviornments"
  default = {
    dev  = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}
variable "int_port" {
  type    = number
  default = 1880
  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

variable "ext_port" {
  # type = number
  # type = list(any)
  # changed the code to reflect different ports for dev and prod
  type = map
  validation {
    #condition = var.ext_port <= 65535 && var.ext_port > 0
    # condition is replace with min and max functions as the variable is now list
    #condition     = max(var.ext_port...) <= 65535 && min(var.ext_port...) > 0
    #error_message = "The external port must be valid port range 0 - 65535."
    # changed the code to use differnt ports for dev and prod
    condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) >= 1980
    error_message = "The external port for development must be valid port range 1980 - 65535."
  }
  validation {
    condition     = max(var.ext_port["prod"]...) < 1980 && min(var.ext_port["prod"]...) >= 1880
    error_message = "The external port for production must be valid port range 1880 - 1979."
  }
  #sensitive = true
}

# variable "container_count" {
#   type = number
#   default = 1
# }

# Variable "container_count" is replaced with local variable
locals {
  #container_count = length(var.ext_port[terraform.workspace])
  # adding different container counts based on the port assignment for different environments
  container_count = length(var.ext_port[terraform.workspace])
}