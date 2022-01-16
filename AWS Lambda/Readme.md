## Simple Setup
1- install python 3.9  
2- install aws cli  
3- install aws sam cli  
4- in console create a user for programatic and export the csv with credentials  
5- run 'aws configuration' and pass the info in credentials file  
6- go to a folder of choice and and via cmd run 'sam init'  
      - select 1, quick templates  
      - zip  
      - select python  
      - name it  
      -   
7- 'sam build --guided' to build the file and depencies to deploy (use guided only in the first deploy)  
8- 'sam validate' to validate the template.yml  
9- 'sam deploy --stackname' to deploy to lambdas  

## Test locally
1- everything before should work  
2- install docker  
3- run below command  
4- 'sam local invoke <function name under resource in template.yml> --event <paht to a json file with the event body>'
   'sam local invoke HelloWorldFunction --event events/event.json'

## Degub logs
1- run  
    'sam logs -n HelloWorldFunction --region us-east-1 --stack-name firstlambda --tail'
    'sam logs -n <function name under resource in template.yml> --region <region the function was deploied> --stack-name <name given while deploying first time> --tail'  
2- if nothing shows up, trigger the function manually in console and the logs will appear  

## Security
1- IAM Resource Policy: policy of a resource, if he is allowed or not to trigger a function  
2- IAM (execution) Role: role and policy of what a function can interact with  

## Cleanup
1- delete the stack builded  
    'aws cloudformation --region <region the function was deploied>  delete-stack --stack-name <name given while deploying first time>'
    'aws cloudformation --region us-east-1 delete-stack --stack-name firstlambda'  

## Invoke Deployed Lambda from local
### Asyc (no answer back)
1- deploy it to cloud  
2- run  
    aws lambda invoke --invocation-type Event --region <functions region> --function-name <function name after deployed in console> <outputfile.txt>
    - event type is for asych function
    aws lambda invoke --invocation-type Event --region us-east-1 --function-name firstlambda-HelloWorldFunction-EhNmuRaBWEB1 outputfile.txt

### Sync (reveive answer)
1- make sure your function return something  
2- deploy  
3- run  
    aws lambda invoke --invocation-type RequestResponse --region us-east-1 --function-name  
    firstlambda-HelloWorldFunction-EhNmuRaBWEB1 outputfile.txt  
4- should have an outputfile.txt in the folder you ran it

## Cold Start
when a variable is created outside the function to be reused globally
if the variable should change every invocation, should not use it as global because lambda keep the first execution as a buffer for some time

## Test API Locally
1- configure the API event under the serverless resource:  
```yml
Resources:
  CreateOrderFunction:
    Type: AWS::Serverless::Function # More info about Function Resource: https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#awsserverlessfunction
    Properties:
      CodeUri: orders_api/
      Handler: create.lambda_handler
      Runtime: python3.9
      Events:
        CreateOrder: # name of the api trigger event
          Type: Api # type of event
          Properties:
            Path: /orders # path used in the api as parameter
            Method: POST # method used in the API
```
2- Build  
3- run   
    sam local start-api  
4- get the localhost:3000 paths generated and run on postman as it was an api gateway url  ˇ
