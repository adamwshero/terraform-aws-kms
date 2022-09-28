{
    "Version": "2012-10-17",
    "Id": "1",
    "Statement": [
        {
            "Sid": "Account Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${iam_role_arn}"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Enable IAM policies",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}