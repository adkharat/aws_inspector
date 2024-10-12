# -*- coding: utf-8 -*-
import os
import json
import boto3
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication

ses = boto3.client("ses")
s3 = boto3.client("s3")

SENDER_EMAIL = "shaikamanulla881@gmail.com"
TO_EMAILS = ["shaikamanulla881@gmail.com"]

def send_email(sender, receiver, subject, body, file_content, file_name):
    msg = MIMEMultipart()
    msg["Subject"] = subject
    msg["From"] = sender
    msg["To"] = ",".join(receiver)

    body_txt = MIMEText(body, "html")
    attachment = MIMEApplication(file_content)
    attachment.add_header("Content-Disposition", "attachment", filename=file_name)

    msg.attach(body_txt)
    msg.attach(attachment)

    response = ses.send_raw_email(
        Source=sender, Destinations=receiver, RaawMessage={"Data": msg.as_string()}
    )

    return response

def lambda_handler(event, context):
    if "Records" in event:
        records = event["Records"][0]
        action = records["eventName"]
        ip = records["requestParameters"]["sourceIPAddress"]
        bucket_name = records["s3"]["bucket"]["name"]
        file_object = records["s3"]["object"]["key"]

        fileObj = s3.get_object(Bucket=bucket_name, Key=file_object)
        file_content = fileObj["Body"].read()
        file_name = file_object.split("/")[-1]

        # Debugging print statements
        print("bucketName --- : " + bucket_name)
        print("objectName --- : " + file_object)
        print("fileObj --- : " + str(fileObj))  # Fixed here
        print("file_content --- : " + file_content.decode('utf-8'))  # Convert to string
        print("file_name --- : " + file_name)
    
        subject = f"Golden Image Vulnerability report generated on S3:{bucket_name} - {str(action)}"
        body = """
            Hey,<br>
        
            Welcome to AWS S3 notification<br>
            
            We are here to notify you that vulnerability report is generated.<br>
            This email is to notify you regarding {} event.<br>
            Vulnerability report {} is Uploaded.<br>
            Source IP: {}<br>
        """.format(
            action, file_object, ip  # Corrected 'object' to 'file_object'
        )

        response = send_email(
            SENDER_EMAIL, TO_EMAILS, subject, body, file_content, file_name
        )

        if response["ResponseMetadata"]["HTTPStatusCode"] == 200:
            return {"statusCode": 200, "body": json.dumps("Email sent successfully!")}

    return {"statusCode": 500, "body": json.dumps("Email delivery failed!")}