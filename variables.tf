variable "company" {
  type = string
  description = "This variable defines the company name used to build resources"
}

variable "app_name" {
  type = string
  description = "This variable defines the application name used to build resources"
}

variable "environment" {
  type = string
  description = "This var defines the environment to be built"
}

variable "location" {
  type = string
  description = "Azure region where the resource group will be created"
  default = "north europe"
}
