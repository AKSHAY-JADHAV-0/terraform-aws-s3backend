#creating i am role for eks.
data "aws_caller_identity" "current" {}

locals {
    principal_arns = var.principal_arns != null ? var.principal_arns : [data.aws_caller_identity.current.arn]

    assume_role_policy_document = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "AWS": local.principal_arns
        },
        "Action": "sts:AssumeRole"
        }
    ]
})
}

resource "aws_iam_role" "iam_role" {
    name               = "${local.namespace}-tf-assume-role"
    assume_role_policy = local.assume_role_policy_document
}

resource "aws_iam_role" "iam_role" {
    name               = "${local.namespace}-tf-assume-role"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
        {  
        "Action": "sts:AssumeRole",
        "Principal": {
            "AWS": local.principal_arns
        },
        "Effect": "Allow"
        }
    ]
    })

    tags = {
        ResourceGroup = local.namespace
    }
}

data "aws_iam_policy_document" "policy_doc" {
    statement {
        actions    = ["s3:ListBucket"]
        resources  = [aws_s3_bucket.s3_bucket.arn]
    }

    statement {
        actions    = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        resources  = ["${aws_s3_bucket.s3_bucket.arn}/*"]
    }

    statement {
        actions    = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
        resources  = [aws_dynamodb_table.dynamodb_table.arn]
    }
}

resource "aws_iam_policy" "iam_policy" {
    name  = "${local.namespace}-tf-policy"
    policy = data.aws_iam_policy_document.policy_doc.json
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
    role       = aws_iam_role.iam_role.name
    policy_arn = aws_iam_policy.iam_policy.arn
}
