
# create s3 bucket

resource "aws_s3_bucket" "s3bucketdemo777" {
  bucket = "s3bucketdemo777"
  force_destroy = true
}

# uplaod files to s3 bucket

resource "aws_s3_bucket_object" "upload_file" {
for_each = fileset("files/", "*")
bucket = aws_s3_bucket.s3bucketdemo777.id
key = each.value
source = "files/${each.value}"
}

# policy for s3 bucket

resource "aws_s3_bucket_policy" "cloudfront_access_policy" {
  bucket = aws_s3_bucket.s3bucketdemo777.id
  #policy =  file("${path.module}/bucket_policy.json")
#}
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.s3_oai.iam_arn
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.s3bucketdemo777.arn}/*",
      },
    ]
  })
}

# website configuration for s3 bucket


resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.s3bucketdemo777.id

  index_document {
    suffix = "index.html"
  }

}

# cloudfront distribution

resource "aws_cloudfront_origin_access_identity" "s3_oai" {
  comment = "Access Identity for S3 Bucket"
}
  
resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = aws_s3_bucket.s3bucketdemo777.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.s3bucketdemo777.id

    s3_origin_config {
       origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.s3_oai.id}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for static website"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = aws_s3_bucket.s3bucketdemo777.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  
#   viewer_certificate {
#     acm_certificate_arn = ""
#     ssl_support_method  = "sni-only"
#     minimum_protocol_version = "TLSv1.2_2018"
#   }


viewer_certificate {
    cloudfront_default_certificate = true
  }


}
