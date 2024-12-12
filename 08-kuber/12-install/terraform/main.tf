module "control_plane" {
  source             = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  network_id         = yandex_vpc_network.vpc.id
  subnet_zones       = [var.cp_params.zone]
  subnet_ids         = [yandex_vpc_subnet.subnet[var.cp_params.zone].id]
  instance_name      = var.cp_params.instance_name
  instance_count     = var.cp_params.count
  instance_cores     = var.cp_params.instance_cores
  instance_memory    = var.cp_params.instance_memory
  boot_disk_size     = var.cp_params.boot_disk_size
  image_family       = var.cp_params.image_family
  public_ip          = var.cp_params.public_ip

  metadata = {
    user-data          = data.template_file.web_cloudinit.rendered
    serial-port-enable = 1
  }
}

module "workers" {
  source             = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  network_id         = yandex_vpc_network.vpc.id
  subnet_zones       = [var.worker_params.zone]
  subnet_ids         = [yandex_vpc_subnet.subnet[var.cp_params.zone].id]
  instance_name      = var.worker_params.instance_name
  instance_count     = var.worker_params.count
  instance_cores     = var.worker_params.instance_cores
  instance_memory    = var.worker_params.instance_memory
  boot_disk_size     = var.worker_params.boot_disk_size
  image_family       = var.worker_params.image_family
  public_ip          = var.worker_params.public_ip

  metadata = {
    user-data          = data.template_file.web_cloudinit.rendered
    serial-port-enable = 1
  }
}

data "template_file" "web_cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    username       = var.username
    ssh_public_key = file(var.ssh_public_key)
    packages       = jsonencode(var.web_packages)
  }
}