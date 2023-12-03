resource "vcd_vapp_vm" "vm" {
  # ... (existing configurations)

  network {
    type               = "org"
    name               = var.network_name
    ip_allocation_mode = "DHCP"
    mac                = var.mac[count.index]
    is_primary         = true
  }

  # Apply network_nfs only for compute_ip_addresses and compute_infra_ip_addresses
  dynamic "network" {
    for_each = var.compute_ip_addresses + var.compute_infra_ip_addresses
    content {
      type               = "org"
      name               = var.network_nfs
      ip_allocation_mode = "POOL"
      is_primary         = false
    }
    # Add a condition to apply network_nfs only for compute machines
    condition = can(index(var.compute_ip_addresses, network.value)) || can(index(var.compute_infra_ip_addresses, network.value))
  }

  override_template_disk {
    bus_type    = "paravirtual"
    size_in_mb  = var.disk_size * 1024
    bus_number  = 0
    unit_number = 0
  }
}

In this modification:

    The dynamic block is used to iterate over the combined list of compute_ip_addresses and compute_infra_ip_addresses.
    The condition within the dynamic block checks whether the current IP address belongs to either compute_ip_addresses or compute_infra_ip_addresses.
    If the condition is true, the network_nfs configuration is included; otherwise, it's skipped.

This way, the network_nfs will only be applied to VMs with IP addresses listed in compute_ip_addresses and compute_infra_ip_addresses. Adjustments can be made based on your specific requirements and the structure of your Terraform configuration.
