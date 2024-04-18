terraform {
    required_version = ">= 0.15"

    backend "s3backend" {
        bucket         = "team-rocket-create"
        key            = "jesse/james"
        region         = "ap-south-1"
        encrypt        = true
        role_arn       = "arn:aws:iam::215974853022:role/team-rocket-1qh28hgo0g1c-tf-assume-role"
        dynamodb_table = "team-rocket-1qh28hgo0g1c-state-lock"
    }
}

resource "null_resource" "motto" {
    triggers = {
        always = timestamp()
    }

    provisioner "local-exec" {
        command = "echo gotta catch em all"
    }
}
