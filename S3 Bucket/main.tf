
resource "aws_s3_bucket" "s3bucketdemo777"{
  bucket = "s3bucketdemo777"
}

#resource "aws_s3_bucket_object" "upload_file" {
  #bucket = "s3bucketdemo777"
  #key    = "beach.webp"
  #source = "beach.webp"

#depends_on = [aws_s3_bucket.s3bucketdemo777]
#}

resource "aws_s3_bucket_object" "upload_file" {
for_each = fileset("files/", "*")
bucket = aws_s3_bucket.s3bucketdemo777.id
key = each.value
source = "files/${each.value}"
}

resource "aws_s3_bucket_policy" "public_bucket_policy" {
  policy = file("${path.module}/bucket_policy.json")
  bucket = aws_s3_bucket.s3bucketdemo777.id
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.s3bucketdemo777.id

  index_document {
    suffix = "index.html"
  }

}
  

