variable "location" {}

variable "prefix" {
    type = string
    default = "my"
}

variable "tags" {
    type = map

    default = {
        Environment = "Dev"
        Dept = "Kestral"
  }
}

variable "sku" {
   type = map
    default = {
        westus = "16.04-LTS"
        eastus = "18.04-LTS"
    }
}
