provider "aws" {
  region = "eu-central-1"
}

resource "random_id" "rand" {
  byte_length = 4
}

resource "aws_s3_bucket" "website" {
  bucket = "emi-terraform-website-${random_id.rand.hex}"

  tags = {
    Name = "emi-terraform-website"
  }
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action   = ["s3:GetObject"],
        Resource = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}


resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}
