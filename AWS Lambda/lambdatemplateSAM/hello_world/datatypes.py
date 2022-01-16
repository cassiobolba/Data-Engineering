import time
import os # to get env variables created from template.yml
import random

def simple_types(event,context):
    print(event)
    return event

def list_types(event,context):
    print(event)
    student_scores = {"Cassio" : 100, "Victoria" : 100, "Garfinho" : 90 }
    score_list = []
    for name in event:
        score_list.append(student_scores[name])
    return score_list

def dict_types(event,context):
    for score in event["Cassio"]:
        print(score)
    return event

def context_example(event, context):   
    print("Lambda function ARN:", context.invoked_function_arn)
    print("CloudWatch log stream name:", context.log_stream_name)
    print("CloudWatch log group name:",  context.log_group_name)
    print("Lambda Request ID:", context.aws_request_id)
    print("Lambda function memory limits in MB:", context.memory_limit_in_mb)
    # We have added a 1 second delay so you can see the time remaining in get_remaining_time_in_millis.
    time.sleep(1) 
    print("Lambda time remaining in MS:", context.get_remaining_time_in_millis())
    print(os.getenv('restapi')) 
    return context.invoked_function_arn

global_var = random.random()
def cold_start(event,context):
    exec_time_var = random.random()
    return global_var,exec_time_var