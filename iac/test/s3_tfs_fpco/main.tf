module "s3-remote-state-bucket" {
    source      = "../fpco"
    bucket_name = "${var.bucket_name}"
    table_name  =  "${var.table_name}"
}







