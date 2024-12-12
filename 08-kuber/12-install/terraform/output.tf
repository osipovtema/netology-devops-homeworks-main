# output "lb_internal_ip" {
#   description = "Internal LB IP address"
#   value = {
#     ip = yandex_lb_network_load_balancer.cp.listener.*.internal_address_spec[0]
#   }
# }


resource "local_file" "inventory" {
  content = templatefile(
    "${path.module}/inventory.tftpl", {
      control_planes = {
        for idx, v in module.control_plane.fqdn : v => {
          external_ip_address = module.control_plane.external_ip_address[idx]
          internal_ip_address = module.control_plane.internal_ip_address[idx]
        }
      }
      workers = {
        for idx, v in module.workers.fqdn : v => {
          external_ip_address = module.workers.external_ip_address[idx]
          internal_ip_address = module.workers.internal_ip_address[idx]
        }
      }
    }
  )
  filename = "../inventory/cluster/hosts.yml"
}