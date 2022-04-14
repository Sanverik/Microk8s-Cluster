locals {
  tenancy_ocid   = "ocid1.tenancy.oc1..aaaaaaaaqgqniafsc5pk2svpbbxmsv66ot5zqyrhurvap5k3zos47q2fph4q"
  prefix         = "oracle-microk8s"
  enable_workers = true
  ssh_authorized_keys = chomp(file("~/.ssh/id_rsa.pub"))
  tags = {
    CreatedBy = "Terraform"
  }
}