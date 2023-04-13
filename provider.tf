terraform {
  required_providers {
    citrixadc = {
      source = "citrix/citrixadc"
    }
  }
}
provider "citrixadc" {
//insert endpoint, username, password 
  endpoint = var.Endpoint_Data["endpoint"]
  username = var.username
  password = var.password


}



