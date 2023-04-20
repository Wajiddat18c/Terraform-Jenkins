

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
  partitionname = var.partitionname
  maxbandwidth  = var.maxbandwidth
  maxconn       = var.maxconn
  maxmemlimit   = var.maxmemlimit

}

resource "citrixadc_vlan" "tf_vlan" {
    vlanid = var.vlan
    aliasname = citrixadc_nspartition.tf_nspartition.partitionname
    mtu = 1500

}
 

resource "citrixadc_vlan_interface_binding" "tf_bind" {
    vlanid = citrixadc_vlan.tf_vlan.vlanid
    #PROD LA/1
    ifnum = "0/1"
    tagged = "true"

      depends_on = [
    citrixadc_vlan.tf_vlan
  ]


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
        policyname = "partition-operator"
        priority = 110
    }

    lifecycle {
      prevent_destroy = true
    }

}


resource "citrixadc_systemgroup_nspartition_binding" "tf_systemgroup_nspartition_binding" {
  groupname     = citrixadc_systemgroup.tf_systemgroup.groupname
  partitionname = citrixadc_nspartition.tf_nspartition.partitionname


}


resource "citrixadc_systemgroup_nspartition_binding" "tf_systemgroup_nspartition_binding1" {
  groupname     = citrixadc_systemgroup.tf_systemgroup1.groupname
  partitionname = citrixadc_nspartition.tf_nspartition.partitionname


}

resource "citrixadc_systemgroup_nspartition_binding" "tf_systemgroup_nspartition_binding2" {
  groupname     = "g_ncop_lba_prod_partition-infrastructure-service-user"
  partitionname = citrixadc_nspartition.tf_nspartition.partitionname


}



resource "citrixadc_nspartition_vlan_binding" "tf_binding" {
  partitionname = citrixadc_nspartition.tf_nspartition.partitionname
  vlan          = citrixadc_vlan.tf_vlan.vlanid


}
