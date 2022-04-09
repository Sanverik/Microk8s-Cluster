resource "oci_identity_compartment" "this" {
  compartment_id = data.oci_identity_compartment.root.compartment_id
  name           = "Terraform"
  description    = "All stuff for tf"
}

resource "oci_core_instance" "master" {
  availability_domain = data.oci_identity_availability_domains.this.availability_domains[0].name
  compartment_id      = oci_identity_compartment.this.id
  shape               = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = 12
    ocpus         = 2
  }

  source_details {
    source_id   = lookup(data.oci_core_images.this.images[0], "id")
    source_type = "image"
  }

  display_name = "master-vm"

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.this.id
    nsg_ids = [
      oci_core_network_security_group.this.id
    ]
  }
  metadata = {
    ssh_authorized_keys = chomp(file("~/.ssh/id_rsa.pub"))
  }
  preserve_boot_volume = false
}

resource "oci_core_instance" "worker" {
  count               = local.enable_workers ? 2 : 0
  availability_domain = data.oci_identity_availability_domains.this.availability_domains[0].name
  compartment_id      = oci_identity_compartment.this.id
  shape               = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = 8
    ocpus         = 1
  }

  source_details {
    source_id   = lookup(data.oci_core_images.this.images[0], "id")
    source_type = "image"
  }

  display_name = "worker${count.index + 1}-vm"

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.this.id
    nsg_ids = [
      oci_core_network_security_group.this.id
    ]
  }
  metadata = {
    ssh_authorized_keys = chomp(file("~/.ssh/id_rsa.pub"))
  }
  preserve_boot_volume = false
}