terraform {
  required_providers {
    citrixadc = {
      source = "citrix/citrixadc"
      version = "1.33.0"
    }
  }
}
provider "citrixadc" {
//insert endpoint, username, password 
  endpoint = var.endpoint
  username = var.username
  password = var.password


}



