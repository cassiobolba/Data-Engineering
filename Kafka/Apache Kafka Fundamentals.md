# 2. MOTIVATIONS & CUSTOMER USE CASES
* Shift to Event-driven Systems
    * such as facebook feed and online news 
* Leave the state-driven systems as mostly use now 
    * such as phone call, paper news 
## Motivation leads to:
* Have a **single platform** to connect everyonbe to every event
* **Real time** stream of events
* **All events stored** for historical view

## Event Driven Businesses:
* Social Networks
* On-demand digital content
* Online news
* Credic Card Payments
* Ride hailing in uber
* IoT real-time traffic routing

## Kafka offer:
* It is the standard for real time event streaming
* Global Scale
* Real-time
* Persistent Storage
* Stream Processing
* Can integrate with other systems
* Process one event at time with stream processors

## Event Driven - Use Cases:
* Reak-Time Fraud Detection
    * act rapidly
    * minimize risk
    * improve experience
* Automotive
    * straming platform
    * cameras
    * telemetry
    * sensors
* Real-time e-commerce
    * click stream analysis
    * fast answer and custom experience
* customer 360
    * improve data integration
    * increase up-sell and cross-sell
    * increase scalability
    * save costs
* Banking
    * fast transaction
    * improve scalability
    * empower AI for chatbots
* healt care
    * microservices
    * iot
    * realtime care
* Online Gaming
    * real time game
    * faster ramp time
    * process data at scale
    * increase realiability
* Financial Services
* Gov applications

# 3. APACHE KAFKA FUNDAMENTALS
## 3.1 PRODUCER
* Aplication you write to put data in Kafka Cluster
* **ACK/NAK**
    * message sent back from cluster to producer to say that the message was received
* Can be written in java, python, C, Go, .Net
* Rest proxy for any unsupported language
* CLI Producer Tool

## 3.2 KAFKA BROKERS
* Composed inside the Cluster
* Can think as a machine in a server
* Every Broker has its ouwn storage/disk
* Retention time: Time to stage the data in the broker
* They might be container, vms, machines, servers....
* Manage the logs files/messages
* Manage many partitions inside the broker disk
* Takes inputs from producer > store it to a partition > deliver to a consumer
* Broker can be **replicated** by a replication factor
* 1 replica is the leader, the other are the followers

## 3.3 CONSUMER
* Programer you write to read data
* Data records come from it
* Pull messages from topics
* New inflowing messages are automatically retrieved
* Consumer offset
    * keep track of the last message read
    * is sotred in a special topic
* CLI tools exist to red from the cluster

## 3.4 ZOOKEEPER
* Manage the brokers
* There is a work to remove it from the architecture
* One day zookeeper will no longer be user
* Failure detection and Recovery
* electing the new Master in case of failure
* Store ACLs and Secrets

## 3.5 DECOUPLING PRODUCERS AND CONSUMERS
* Producers and Consumers are decoupled
* Slow consumers not affect producers
* Add Consumers without affecting producers
* Failure of consumer does not affect the system
* A producers does not know a consumer exists unless you tell them via Topic

## 3.6 TOPICS
* Sequence of events
* Streams of related messages in kafka
* Categorize message into groups
* There is a logical limit of topics, based on partitions
* Developers define topics
* Producers can have n to n relationship with producers
* Topic is  **Durable Logs** persisted in some place
* Topics can be partitioned and distribute the partitions to separate brokers
* You add messages in the end of segments of the partition ALWAYS

## 3.7 LOGS
* In the logs, things are organized by time
* always add logs at the end
* Logs are imutable, what ahppened can be changed
* Consumer can read as many messages available, and do not destroy them

## 3.8 STRUCTURE OF A MESSAGE -  DATA ELEMENTS
Inside a Record:
* Header (optional - metadata)
* Key
* Value
* Timestamp (creation time or ingestion time)

## 3.9 LOAD BALANCING AND SEMANTIC PARTITION
* By default it does a round-robbin message distribution if there is no key
* Can order event by key if needed by a hash key
    * so the messages with same key will land in same partition



