data "aws_s3_bucket" "existing_bucket" {
bucket = "my-bucket2000"

}
resource "aws_s3_bucket" "terraform_state"{
    bucket = "my-bucket2000"
   lifecycle {
         prevent_destroy = true
   } 
  }

resource "aws_s3_bucket_versioning" "enable"{
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
}

terraform {
    
  backend "s3" {
    bucket = "my-bucket2000"
      key   = "terraform.tfstate"
    region = "us-east-1"
  }
}

