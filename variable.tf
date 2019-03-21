variable "webserver_ssh_key_public" {
  default     = "~/.ssh/personal/webserver.pub"
  description = "ssh public key for the aws instance"
}

variable "webserver_ssh_key_private" {
  default     = "~/.ssh/personal/webserver"
  description = "ssh private key for the aws instance"
}

variable "github_ssh_key_private" {
  default     = "~/.ssh/personal/github"
  description = "ssh private key for the github instance"
}

variable "github_ssh_key_public" {
  default     = "~/.ssh/personal/github.pub"
  description = "ssh public key for the github instance"
}
