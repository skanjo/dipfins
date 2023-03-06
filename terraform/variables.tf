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