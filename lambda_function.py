import boto3
import json

def lambda_handler(event, context):
    
    # Print the event message for debugging purposes
    print("Received event: " + json.dumps(event, indent=2))

    for e in event["Records"]:
        bucketName = e["s3"]["bucket"]["name"]
        objectName = e["s3"]["object"]["key"]
        eventName = e["eventName"]
        
    print("bucketName --- : " + bucketName)
    print("objectName --- : " + objectName)
    print("eventName --- : " + eventName)
    
    bClient = boto3.client("ses")
    
    eSubject = 'Golden Image ' + Vulnerability report generated
        
    eBody = """
        <br>
        Hey,<br>
        
        Welcome to AWS S3 notification lambda trigger<br>
        
        We are here to notify you that vulnerability report is generated
        S3 Bucket name : {} <br>
        Vulnerability report name : {}
        <br>
    """.format(bucketName, objectName)
    
    send = {"Subject": {"Data": eSubject}, "Body": {"Html": {"Data": eBody}}}
    print("Before sending --- : ")
    result = bClient.send_email(Source= "shaikamanulla881@gmail.com", Destination= {"ToAddresses": ["shaikamanulla881@gmail.com"]}, Message= send)
    print("After sending --- : ")
    return {
        'statusCode': 200,
        'body': json.dumps(result)
    }    