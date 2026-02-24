terraform {
  backend "s3" {
    bucket         = "raida-terraform-state"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}