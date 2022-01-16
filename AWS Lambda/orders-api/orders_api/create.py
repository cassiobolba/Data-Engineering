import json
import boto3
import os

def lambda_handler(event, context):
    order = json.loads(event['body'])

    dynamodb = boto3.resource('dynamodb') # tell boto what resource you are using
    table_name = os.environ.get('ORDERS_TABLE') # get the value from global function defined on yml
    table = dynamodb.Table(table_name) # get table from dynamo db
    response = table.put_item(TableName = table_name, Item=order) #use put item method on table, to put the order coming from body
    print(response) # write response to the logs
    return {
        'statusCode': 201,
        'headers': {},
        'body': json.dumps({'messagem':'order created'})
    }