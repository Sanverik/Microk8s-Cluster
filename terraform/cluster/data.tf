data "oci_identity_compartment" "root" {
  id = local.tenancy_ocid
}

data "oci_identity_availability_domains" "this" {
  compartment_id = oci_identity_compartment.this.id
}

data "oci_core_images" "this" {
  compartment_id           = oci_identity_compartment.this.id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "20.04"
}