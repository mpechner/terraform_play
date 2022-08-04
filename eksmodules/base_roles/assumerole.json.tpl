
{
  "Version":"2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect": "Allow",
        "Sid" : "${sid}",
        "Principal" : {
          "Service" : "${service}.amazonaws.com"
        }
      }
    ]
  }