*notes from marc lamberti course*

# Intro to Airbyte
## Why Airbyte?
Use cases
* not use created custom script
* covers most of your souces and destinations
* several connectors available and many to come
* unified view os all integrtions in the same place
* need to monitor schema changes to avoid brakes and do not want create a custom solution
* can use CDC

## What is Airbyte?
Open-Source data integration tool that moves data from one system to another. some benefits are:
* Open source, can create connectors and use comunity ones
* Great community in slack
* User interface is very freindly
* Scalable, can work with great amount fo data
* Extensible because you can create your own connector with the SDK or with the connector builder tool
* Can be used in the EL part of the pipeline and in the Publish part, where you send data to other systems and tools

## Core Concepts
* Source: where you want to get the data
* Destination: Where you want to write the data
* Connector: pull or push data from source to destination
* Stream: Group of related records in a file or tables
* Field: columns or key pais from a json, in a stream
* Connection: Configure settings between source and destination

## Core Components
* Airbyte DB (config DB): Sotres all the connection metadata (credentials, frequency...)
* Airbyte WebApp: User UI, port 8000
* Airbyte Server (API): API to create and manage resources, everything done in the UI use APIs to communicate to other componenets
* Airbyre Scheduler: Schedule jobs (sync,check,discover,etc) using API
* Airbyte Workers: where the job is executed, pull jobs from a queue and execute them

## Where NOT use Airbyte:
* Streaming, is meant for batches 
* If do not want to create a customr connector in case your needed ones are not there

## Airbyte Cloud vs OSS?

# Getting Started with Airbyte
## Docker
* enter in the folder with docker compose files
* execute `docker compose -f airbyte-docker-compose.yml up -d`
## Airbyte UI
## Source and Destination
Google Spreadsheet
* Place the file in the drive folder
* create a new project in the same GCP account you used the drive folder
* enable google spread sheet api in apis & services
* create a service account to enable this appi
    * select the api
    * choose application data > next
    * give a name > continue
    * roles = owner > continue > done
* now go to IAM and create a service account
    * select aurbyte role > create key > json 
    * copy and paste all content in airbyte
    * get the service account email in details tab
    * grant access in the spreadsheet to the email with editor access
    * copy the link of the spreadsheet into airbyte

Big Query
* Enable billing in the project
* Find the project id and paste in airbyte
* On Bq create a dataset in the project tree
* set the project id, set the destination location US, and name as the dataset created
* paste the service key
* test

## Connection
* name it meaninfully
* select schedule
* destination namespace: default will default to the dataset name
* Stream prefix: each table will have the same name as the tab name, can add prefix. 
    * remember, streams are the group of objects in a source
* Detect propagate schema changes
    * propagate files changes only
    * propagate all filed and stream changes
    * detect changes and manually approve
    * detect changes and pause connection
* can select which stream and columns to sync
* sync modes:
    * full refresh / overwrite
    * full refresh / append

