provider "aws" {
    region = "us-west-1"
}

resource "aws_cloudfront_distribution" "my_distribution" {
  aliases = ["danielher.com"]

  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_100"
  wait_for_deployment = true

  default_root_object = "index.html"

  origin {
    domain_name = "resumechallengebucket1.s3-website-us-west-1.amazonaws.com"
    origin_id   = "danielher.com"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "DELETE", "PATCH"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "danielher.com"
    compress         = true

    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:453846582175:certificate/bbf4d51f-04b4-46bf-8d5f-3d3899d83c4b"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

resource "aws_lambda_function" "visitor_count_function" {
  function_name = "visitorcount"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = "arn:aws:iam::453846582175:role/service-role/visitorcount-role-gb0lef8v"
  memory_size   = 128
  timeout       = 3

  filename = "${path.module}/../build/lambda_function.zip"

  ephemeral_storage {
    size = 512
  }

  tracing_config {
    mode = "PassThrough"
  }

  # You can add more configuration if needed, such as code zip or other attributes
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "resumechallengebucket1"
}

resource "aws_s3_bucket_website_configuration" "my_bucket_website" {
  bucket = aws_s3_bucket.my_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "s3:GetObject",
      Effect    = "Allow",
      Principal = "*",
      Resource  = "arn:aws:s3:::resumechallengebucket1/*",
      Sid       = "PublicReadGetObject"
    }]
  })
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "cloudresumechallengetftf"
    key            = "dev/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}