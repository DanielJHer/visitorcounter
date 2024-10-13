import json
import boto3
from datetime import datetime
from botocore.exceptions import ClientError
from decimal import Decimal

# initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')

# helper function to convert decimal to int/float
def convert_decimal(obj):
    if isinstance(obj, Decimal):
        return int(obj) if obj %1 ==0 else float(obj)
    raise TypeError

def lambda_handler(event, context):
    try: 
        http_method = event['httpMethod']
        
        if http_method == 'POST':
            # specify table
            table = dynamodb.Table('visitorcount')
            
            # update the visitor count atomically
            response = table.update_item(
                Key={'id':1},
                UpdateExpression="ADD visitor_count :inc",
                ExpressionAttributeValues={':inc':1},
                ReturnValues="UPDATED_NEW"
                )
                
            # retrieve updated visitor count value
            updated_count = response['Attributes']['visitor_count']
            
            # return updated visitor count
            return {
                'statusCode': 200,
                'body': json.dumps({'visitor_count': convert_decimal(updated_count)})
            }
        
        elif http_method == 'GET':
            # Retrieve current visitor count
            response = table.get_item(Key={'id': '1'})
        
            if 'Item' in response:
                current_count = response['Item']['visitor_count']
            else:
                current_count = 0  # If no count is found, default to 0
            
            return {
                'statusCode': 200,
                'body': json.dumps({'visitor_count': current_count})
            }
        
        elif event['httpMethod'] == 'OPTIONS':
            return {
                'statusCode': 200,
                'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, POST',
                'Access-Control-Allow-Headers': 'Content-Type'
            },
            'body': json.dumps('CORS preflight response')
        }
        
        else:
            return {
            'statusCode': 405,
            'body': json.dumps('Method Not Allowed')
        }
        
    
    
    except ClientError as e:
        # Catch errors related to DynamoDB and return a meaningful response
        return {
            'statusCode': 500,
            'body': json.dumps(f"Error updating visitor count: {str(e)}")
        }

    except Exception as e:
        # Catch all other exceptions and return a meaningful error message
        return {
            'statusCode': 500,
            'body': json.dumps(f"An error occurred: {str(e)}")
        }
