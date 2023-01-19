variable "vnet_map" {
  type = map(string)
  default = {
    "tax:dev" :"TAX-DEV-VNET",
    "tax:uat" :"TAX-UAT-VNET",
    "tax:prod":"TAX-PROD-VNET"
    
  }
}


/*variable "vnet_name" {
  type    = string
  default = "TAX-DEV-VNET"
}*/

variable "capability" {
  type    = string
}

variable "environment" {
  type    = string
}


