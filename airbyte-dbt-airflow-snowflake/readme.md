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
