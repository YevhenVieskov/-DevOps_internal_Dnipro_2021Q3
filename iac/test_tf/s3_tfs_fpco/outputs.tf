output "bucket_name" {
    value = "${module.s3-remote-state-bucket.bucket_id}"
}


