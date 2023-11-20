variable "sleep" {
  type    = number
  default = 0
}

data "external" "sleep" {
  program = ["sh", "-c", "sleep $1 && echo {}", "-", var.sleep]
  query   = {}
}
