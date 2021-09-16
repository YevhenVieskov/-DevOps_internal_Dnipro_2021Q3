/*terraform {
  required_version = ">= 0.12.6, < 0.14"

  required_providers {
    aws = ">= 2.41, < 4.0"
  }
}*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"      
      version = "~> 3.57"
    }
  }
  
  required_version = ">= 1.0.4"
}
