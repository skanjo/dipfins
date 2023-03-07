variable stage {
  type    = string
  default = "dev"

  validation {
    condition = contains([
      "dev",
      "test"
    ], var.stage)
    error_message = "Argument \"stage\" must be either \"dev\" or \"test\"."
  }
}

variable service_name {
  type    = string
  default = "dipfins-scanner"
}

variable lambda_runtime {
  type    = string
  default = "java11"
}

variable lambda_memory_size {
  type    = number
  default = 512
}

variable lambda_timeout {
  type    = number
  default = 30
}

variable s3_force_destroy {
  type    = bool
  default = true
}

variable s3_versioning_enabled {
  type    = bool
  default = false
}

variable s3_filter_suffix {
  type    = string
  default = ".in.json"
}
