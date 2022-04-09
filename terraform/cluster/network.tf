resource "oci_core_vcn" "this" {
  compartment_id = oci_identity_compartment.this.compartment_id

  cidr_block    = "10.0.0.0/16"
  display_name  = "${local.prefix}-vpn"
  freeform_tags = local.tags
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = oci_identity_compartment.this.compartment_id
  vcn_id         = oci_core_vcn.this.id

  display_name  = "${local.prefix}-igw"
  freeform_tags = local.tags
}

resource "oci_core_route_table" "this" {
  compartment_id = oci_identity_compartment.this.id
  vcn_id         = oci_core_vcn.this.id

  display_name  = "${local.prefix}-rt"
  freeform_tags = local.tags

  route_rules {
    network_entity_id = oci_core_internet_gateway.this.id

    destination = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "this" {
  cidr_block     = cidrsubnet(oci_core_vcn.this.cidr_block, 8, 1)
  compartment_id = oci_identity_compartment.this.id
  vcn_id         = oci_core_vcn.this.id

  display_name   = "${local.prefix}-sbt"
  route_table_id = oci_core_route_table.this.id
  freeform_tags  = local.tags
}

resource "oci_core_network_security_group" "this" {
  compartment_id = oci_identity_compartment.this.id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "Base SG"
}

resource "oci_core_network_security_group_security_rule" "VPC" {
  network_security_group_id = oci_core_network_security_group.this.id

  description = "All within VPC"
  direction   = "INGRESS"
  protocol    = "all"
  source_type = "CIDR_BLOCK"
  source      = oci_core_vcn.this.cidr_block
  destination = oci_core_vcn.this.cidr_block
}

resource "oci_core_network_security_group_security_rule" "ssh" {
  network_security_group_id = oci_core_network_security_group.this.id

  description = "SSH"
  direction   = "INGRESS"
  protocol    = 6
  source_type = "CIDR_BLOCK"
  source      = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "https" {
  network_security_group_id = oci_core_network_security_group.this.id

  description = "HTTPS"
  direction   = "INGRESS"
  protocol    = 6
  source_type = "CIDR_BLOCK"
  source      = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}


