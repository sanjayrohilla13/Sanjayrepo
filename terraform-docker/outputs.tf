# output "container-name" {
#   description = "The name of the container"
#   value       = docker_container.nodered_container[*].name
# }
# output "ip-address" {
#   description = "The ip address"
#   value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
#   #sensitive = true
# }
# moved the output to module output

output "container-name" {
  description = "The name of the container"
  value       = module.container[*].container-name
}

output "ip-address" {
  description = "The ip address"
  value       = flatten(module.container[*].ip-address)
}