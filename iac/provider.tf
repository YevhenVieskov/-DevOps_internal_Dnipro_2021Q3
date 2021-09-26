provider "aws" {
  profile = var.profile
  region  = var.region_jenkins
}

provider "aws" {
  profile = var.profile
  alias   = "peer"
  region  = var.region_peer
}



