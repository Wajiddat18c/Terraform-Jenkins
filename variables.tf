variable "endpoint" {
  type        = string
  description = "Endpoint for subnetip"
}

variable "partitionname" {
  type        = string
  description = "Partition name for the new partition"
  default = ""
}

variable "maxbandwidth" {
  type        = number
  description = "Max bandwidth for the new partition"
  default = 0
}
variable "maxconn" {
  type        = string
  description = "Max connections for the new partition"
  default = "0"
}
variable "maxmemlimit" {
  type        = string
  description = "Max memory limit for the new partition"
  default = "0"
}
variable "vlan" {
  type        = string
  description = "VLAN of the new partition"
  default = "0"
}
