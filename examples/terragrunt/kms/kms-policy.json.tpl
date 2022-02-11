{
    "Id": "key-policy-1",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GrantAccessToCMK",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${sso_admin}"
            },
            "Action": "kms:*",
            "Resource": "*"
        }

    ]
}