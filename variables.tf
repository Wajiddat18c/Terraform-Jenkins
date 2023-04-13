variable "Endpoint_Data" {
  type        = map(string)
  description = "Endpoint for subnetip"
}

variable "partition_setup_data" {
  type        = map(string)
  description = "Data used for creating a new Partition"
}
