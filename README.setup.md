# Repo Setup

## 1. Create an S3 Bucket
Use almost the default settings in the S3 wizard. We named ours "openoakland-infra".

* Enable versioning


## 2. Create a DynamoDB Table
We created ours accordingly:

* *Table Name:* `openoakland_infra`
* *Primary Key:* `LockID`


## 3. Create an IAM policy for people with Terraform permissions

<details>
<summary>Copy this JSON into the IAM policy editor</summary>

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::openoakland-infra"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::openoakland-infra/terraform"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:*:*:openoakland-infra/terraform"
    }
  ]
}
```
</details>

## 4. Initialize the repo
```
terraform init
```
