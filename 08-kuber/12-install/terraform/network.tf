# Создаем облачную сеть
resource "yandex_vpc_network" "vpc" {
  name = var.prod_env.vpc_name
}

# Создаем подсеть в указанной зоне
resource "yandex_vpc_subnet" "subnet" {
  for_each       = { for i in var.prod_env.subnets : i.zone => i }
  name           = "${var.prod_env.vpc_name}-${each.key}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [each.value.cidr]
}


# resource "yandex_lb_target_group" "cp-targets" {
#   name      = "k8s-control-plane-targets"
#   region_id = "ru-central1"
#
#   dynamic "target" {
#     for_each = module.control_plane.internal_ip_address.*
#     content {
#       subnet_id = yandex_vpc_subnet.subnet[var.cp_params.zone].id
#       address   = target.value
#     }
#   }
# }
#
# resource "yandex_lb_network_load_balancer" "cp" {
#   name = "k8s-control-plane-lb"
#   type = "internal"
#
#   listener {
#     name = "k8s-cp"
#     port = 8383
#     target_port = 6443
#     internal_address_spec {
#       subnet_id = yandex_vpc_subnet.subnet[var.cp_params.zone].id
#       address = "10.0.1.200"
#     }
#   }
#
#   attached_target_group {
#     target_group_id = yandex_lb_target_group.cp-targets.id
#
#     healthcheck {
#       name = "k8s-apiserver"
#       tcp_options {
#         port = 6443
#       }
#     }
#   }
# }
