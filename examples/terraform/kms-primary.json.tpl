{
    "Id": "key-policy-1",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM policies",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "GrantSSOAdminAccessToCMK",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${sso_admin}"
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}