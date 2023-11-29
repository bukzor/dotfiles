terraform {
  required_version = "~> 1.6"
  required_providers {
    external = {
      version = "~> 2.3"
      source  = "hashicorp/externall"
    }
  }
}

variable "sleep" {
  type    = number
  default = 0
}

data "external" "sleep" {
  program = ["sh", "-c", "sleep $1 && echo {}", "-", var.sleep]
  query   = {}
}

output "sleep" {
  value = data.external.sleep
}
