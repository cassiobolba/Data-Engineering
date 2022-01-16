import simplejson as json
import boto3
import os
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
    order = {"id" : 123 , "itemName" : "McBook", "quantity" : 100}
    dynamodb = boto3.resource('dynamodb') # tell boto what resource you are using
    table_name = os.environ.get('ORDERS_TABLE') # get the value from global function defined on yml
    table = dynamodb.Table(table_name) # get table from dynamo db
    order_id = int(event['pathParameters']['id']) # read the id passed in the api call
    response = table.query(KeyConditionExpression=Key('id').eq(order_id)) # query the order id
    
    
    return {
        'statusCode': 201,
        'headers': {},
        'body': json.dumps(response['Items'])
    }