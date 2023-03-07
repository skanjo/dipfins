variable service_name {
  description = "The name of the service, used when naming various provisioned resources."
  type    = string
  default = "dipfins-scanner"
}

variable lambda_build_path {
  description = "The path to the local build, used to deploy the lambda."
  type    = string
  default = "../target/dipfins-scanner.jar"
}

variable lambda_handler {
  description = "The name of the Clojure function to handle incoming requests."
  type    = string
  default = "dipfins.core.handler"
}

variable lambda_memory_size {
  description = "The memory allocated to lambda in mgeabytes."
  type    = number
  default = 512
}

variable lambda_runtime {
  description = "The runtime of the used to execute the lambda. This is a Clojure app so java is necessary."
  type    = string
  default = "java11"
}

variable lambda_timeout {
  description = "The maximum time in seconds the lambda will run."
  type    = number
  default = 30
}

variable s3_filter_suffix {
  description = "The object key suffix used to filter lambda trigger to only those files of interest."
  type    = string
  default = ".in.json"
}

variable s3_force_destroy {
  description = "Force deletion of S3 bucket even when the bucket contains objects."
  type    = bool
  default = true
}

variable s3_versioning_enabled {
  description = "Enable object versioning in S3."
  type    = bool
  default = false
}

