provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "ai-stock-pulse"
      ManagedBy   = "terraform"
      Layer       = "foundation"
    }
  }
}
