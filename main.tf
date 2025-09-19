terraform {
  required_version = ">= 1.5.0"
}

variable "example_var" {
  description = "Example variable to trigger a plan change"
  type        = string
  default     = "hello"
}

resource "null_resource" "example" {
  triggers = {
    var_value = var.example_var
  }
}
resource "kubernetes_namespace" "example" {
  metadata {
    name = "sentinel-test"
  }
}
