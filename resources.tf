

 variable "username" {
  description = "Enter your username for the VPX"
  type        = string
}
variable "password" {
  description = "Enter your password for the VPX"
  type        = string
  sensitive = true
}
resource "citrixadc_nspartition" "tf_nspartition" {
  partitionname = var.partition_setup_data["partitionname"]
  maxbandwidth  = var.partition_setup_data["maxbandwidth"]
  maxconn       = var.partition_setup_data["maxconn"]
  maxmemlimit   = var.partition_setup_data["maxmemlimit"]

      lifecycle {
      prevent_destroy = true
    }
}

resource "citrixadc_vlan" "tf_vlan" {
    vlanid = var.partition_setup_data["vlan"]
    aliasname = citrixadc_nspartition.tf_nspartition.partitionname
    mtu = 1500

        lifecycle {
      prevent_destroy = true
    }
}
 

resource "citrixadc_vlan_interface_binding" "tf_bind" {
    vlanid = citrixadc_vlan.tf_vlan.vlanid
    ifnum = "LA/1"
    tagged = "true"

      depends_on = [
    citrixadc_vlan.tf_vlan
  ]

      lifecycle {
      prevent_destroy = true
    }
}



resource "citrixadc_systemgroup" "tf_systemgroup" {
    groupname = "g_ncop_lba_prod_${citrixadc_nspartition.tf_nspartition.partitionname}_admin"
    timeout = 14400
    

    cmdpolicybinding { 
        policyname = "partition-admin"
        priority = 100
    }

    lifecycle {
      prevent_destroy = true
    }
}

resource "citrixadc_systemgroup" "tf_systemgroup1" {
    groupname = "g_ncop_lba_prod_${citrixadc_nspartition.tf_nspartition.partitionname}_maintenance"
    timeout = 14400
    

    cmdpolicybinding { 
        policyname = "partition-maintenance"
        priority = 110
    }

    lifecycle {
      prevent_destroy = true
    }

}


resource "citrixadc_systemgroup_nspartition_binding" "tf_systemgroup_nspartition_binding" {
  groupname     = citrixadc_systemgroup.tf_systemgroup.groupname
  partitionname = citrixadc_nspartition.tf_nspartition.partitionname

      lifecycle {
      prevent_destroy = true
    }
}


resource "citrixadc_systemgroup_nspartition_binding" "tf_systemgroup_nspartition_binding1" {
  groupname     = citrixadc_systemgroup.tf_systemgroup1.groupname
  partitionname = citrixadc_nspartition.tf_nspartition.partitionname

      lifecycle {
      prevent_destroy = true
    }
}

resource "citrixadc_systemgroup_nspartition_binding" "tf_systemgroup_nspartition_binding2" {
  groupname     = "g_ncop_lba_prod_partition-infrastructure-service-user"
  partitionname = citrixadc_nspartition.tf_nspartition.partitionname

        lifecycle {
      prevent_destroy = true
    }
}



resource "citrixadc_nspartition_vlan_binding" "tf_binding" {
  partitionname = citrixadc_nspartition.tf_nspartition.partitionname
  vlan          = citrixadc_vlan.tf_vlan.vlanid

      lifecycle {
      prevent_destroy = true
    }
}
