## CHAPTER 2 - The Data Engineergin Lifecycle
### 2.1 What Is the Data Engineering Lifecycle?
This comprises all stages needed to deliver a data product ready for comsumption by downstream stakeholder. Main steps are: Generation, Storage, Ingestion, Transformation and Serving Data.
[PICTURE LIFECYCLE]. 

#### 2.1.1 The Data Lifecycle Versus the Data Engineering Lifecycle
**DE Lifecycle:** It is just a subset of Data Lifecycle.  
**Data Lifecycle:** All data lifespan from source system where DE have no control until de BI dashboard.

#### 2.1.2 Generation: Source Systems
Some evaluations a DE should consider about the source systems:
* What are the essential characteristics of the data source? Is it an application? A swarm of IoT devices?
* How is data persisted in the source system? Is data persisted long term, or is it temporary and quickly deleted?
* At what rate is data generated? How many events per second? How many gigabytes per hour?
* What level of consistency can data engineers expect from the output data? If you’re running data-quality checks against the output data, how often do data inconsistencies occur—nulls where they aren’t expected, lousy formatting, etc.?
* How often do errors occur?
* Will the data contain duplicates?
* Will some data values arrive late, possibly much later than other messages produced simultaneously?
* What is the schema of the ingested data? Will data engineers need to join across several tables or even several systems to get a complete picture of the data?
* If schema changes (say, a new column is added), how is this dealt with and communicated to downstream stakeholders?
* How frequently should data be pulled from the source system?
* For stateful systems (e.g., a database tracking customer account information), is data provided as periodic snapshots or update events “rom change data capture (CDC)? What’s the logic for how changes are performed, and how are these tracked in the source database?
* Running Analytical queries on source system can affect its performance?
* Who/what is the data provider that will transmit the data for downstream consumption?
* Will reading from a data source impact its performance?
* Does the source system have upstream data dependencies? What are the characteristics of these upstream systems?
* Are data-quality checks in place to check for late or missing data?
* Choose the best approach for schema: *Schemaless* is when you store and adapt the schema as it arrives. Or *fixed schema* is used when already saving data on databases.

#### 2.1.3 Storage
This is one of the most complex stages of data lifecycle as it is present on all stages of a data pipeline. There are many storage solutions (databases, object storage, lakehouse...), they have a variety of purposes. Evaluating storage systems and the mains Key engineering considerations:
* Is this storage solution compatible with the architecture’s required write and read speeds?
* Will storage create a bottleneck for downstream processes?
* Do you understand how this storage technology works? Are you utilizing the storage system optimally or committing unnatural acts? For instance, are you applying a high rate of random access updates in an object storage system? (This is an antipattern with significant performance overhead.)
* Will this storage system handle anticipated future scale? You should consider all capacity limits on the storage system: total available storage, read operation rate, write volume, etc.
* Will downstream users and processes be able to retrieve data in the required service-level agreement (SLA)?
* Are you capturing metadata about schema evolution, data flows, data lineage, and so forth? Metadata has a significant impact on the utility of data. Metadata represents an investment in the future, dramatically enhancing discoverability and institutional knowledge to streamline future projects and architecture changes.
* Is this a pure storage solution (object storage), or does it support complex query patterns (i.e., a cloud data warehouse)?
* Is the storage system schema-agnostic (object storage)? Flexible schema (Cassandra)? Enforced schema (a cloud data warehouse)?
* How are you tracking master data, golden records data quality, and data lineage for data governance? (We have more to say on these in “Data Management”.)
* How are you handling regulatory compliance and data sovereignty? For example, can you store your data in certain geographical locations but not others?

##### 2.1.3.1 Understanding data access frequency
Determine if you data is hot (very often accesed) or cold (mostly not frequently used and mostly archived for auditions). This have a very big impact on cost and the speed of access.

##### 2.1.3.2 Selecting a storage system
Selecting the right storage depeneds on each use case, sucha as volume, drequency of ingestions, format, size and other. There is no unique solution for all cases, and there are countless technologies. More in chapter 6.

#### 2.1.4 Ingestion
Ingestion is the biggest bottleneck on DE mostly because the source systems are out of our control and sudenly can send different data, less data, not data, change without previous notice. Key engineering consideration in this phase:
* What are the use cases for the data I’m ingesting? Can I reuse this data rather than create multiple versions of the same dataset?
* Are the systems generating and ingesting this data reliably, and is the data available when I need it?
* What is the data destination after ingestion?
* How frequently will I need to access the data?
* In what volume will the data typically arrive?
* What format is the data in? Can my downstream storage and transformation systems handle this format?
* Is the source data in good shape for immediate downstream use? If so, for how long, and what may cause it to be unusable?
* If the data is from a streaming source, does it need to be transformed before reaching its destination? Would an in-flight transformation be appropriate, where the data is transformed within the stream itself?
* Streaming must be very carefully evaluated and implemented only if there a use case that bring real benefit over the complexity and costs it brings
* Is it necessary CDC?

#### 2.1.5 Transformation
Now data need to be transformed to start bringing value for downstream user. Key considerations for transformation phase:
* What’s the cost and return on investment (ROI) of the transformation? What is the associated business value?
* Is the transformation as simple and self-isolated as possible?
* What business rules do the transformations support?
* Am I minimizing data movement between the transformation and the storage system during transformation?   
Transformations can happen in batch or streaming, depending the case. Transformations are one of the toughest parts of data lifecycle. Business Logic is the driver of this stage, because this is what might bring value to end user and allow analysis of current status, reporting and ML. Data featurign is also a big part of it, and requires a DS to analize the data and discover the main features for ML and tell DE to implement that automatically in the data pipeline.

#### 2.1.6 Serving Data
The last step after data being collected and transformed, is the step to bring more value from the data. Hopefully at this point the data you are serving is really being used for a purpose, otherwise it will be a wasted pipeline. If data is used, this is where the magic happens: ML can apply forecast, analysts can find oportunities in the data and so on. Let’s look at some of the popular uses of data: analytics, ML, and reverse ETL:

##### 2.1.6.1 Analytics
The main purpose of ETLs normally. Currently divided in 3 facets:
* Business Intelligence: The data you applied business logic is now used to create reports, dashboards and on. Now a days there is also the new Analytc role that cerate a repository of business logic using the raw data you ingested (DBT use by analytis engineers). As the data maturity grows in the company, enabling self service analytics tends to happens. The biggest challenges of self-service analytics are poor data quality, data silos and lack of adequate skills from users perspective.
* Operational Analytics: Details of operations usually near realtime, such as live inventory data, healt monitoring of web pages, and so on. Intended to be real time to react upon it.
* Embedded Analytics: This is when you provide analytics to external cutomers in a platform. Security, data management, trust, permissions and volume of access are much more critical than internal analytics solutions. DEs can use for this multitenancy views which are a set of views containing only data for a specific user, consuming from a mains source which contains all data.
* 
##### 2.1.6.2 Machine Learning
Companies with good maturity can tackle problems with ML. DEs usually help ML and Analytics engineers to set up environment, implement data catalag, lieneage and so on. DEs also support implementation of feature stores for ML engineers. Key considerations when serving data to ML:
* Is the data with sufficient quality? Align with users
* Is data discoverable?
* Where are tech and org. boundaries between a ML and Data Engineer?
* 
##### 2.1.6.3 Reverse ETL
The practice of taking curated data and feed into SaaS and other platforms, and sometimes ingesting it again. Ex. Marketing team read bids for a data, analyize, change and re-upload it again to biding platform.

### 2.2 Major Undercurrents Across the DE Lifecycle (red)
As DE evolved, new practices other than just ETL have been incorporated to the role, such as the undercurrents: Security, Data Management, DataOps, Data Architecture, Orchestration, Soft. Eng. :

IMAGE

#### 2.2.1 Security
This should be top priority, and the concept of least privilege must be used. Give only the inteded access necessary to the tuser execute the task. You also should not have usperuser or admin access all the time. It avoid accidental damage. Use encryption, tokenization, masking, obfuscation and mantain a simple and robust access control.

#### 2.2.2 Data Management
Data best practices once reserved for huge companies—data governance, master data management, data-quality management, metadata management—are now filtering down to companies of all sizes and maturity levels. Data management practices form a cohesive framework that everyone can adopt to ensure that the organization gets value from data and handles it appropriately. Data management has quite a few facets, including the following:
* Data governance, including discoverability and accountability
* Data modeling and design
* Data lineage
* Storage and operations
* Data integration and interoperability
* Data lifecycle management
* Data systems for advanced analytics and ML
* Ethics and privacy

##### 2.2.2.1 Data Governance
According to Data Governance: The Definitive Guide, “Data governance is, first and foremost, a data management function to ensure the quality, integrity, security, and usability of the data collected by an organization. This is key to ensure data is realiable and is being used in the right way. Main categories of data governance are discoverability, security and accountability.

###### 2.2.2.1.1 Data Discoverability
End users should be able to find the right data, know where it comes from, how it relates tp pther data and what the data means. Key areas of dicoverability are metadata management and masterdata management:

###### 2.2.2.1.2 Metadata
Is data about data. There are several automated tools to generate them, but human aspect should no be taken off because it has more knowledge on the area to add. Can come from 2 sources, auto generated and human generated. Wikis are important tools and should contain data experts, sources, owners, consumers, and it is human generated. But it also should be connected to automated tools. DMBOK divides the metada in 4 categories:
* Business Metadata: Identifies businees logic and definition. DEs would consult data catalogs or dictionary to for ie. know the definion of customaer to generate a nes costumer segment table. Is customer who have ever bought or only who bought on the past 90 days.
* Technical metadata: Data created and udes by systems such as data model and schema, lineage, field mappings, and pipeline workflow. 
 * Pipeline metadata show dependencies, schedule, configs, connections and more
 * Lineage metadata tracks origins, dependencies and data changes over time. Provide audit data
 * Schema metadata manages columns for dw, o other data for object store
* Operational metadata: statistics, , job ids,runtime logs, error logs and on.
* Reference Metadata: Data used to classify other data, like look up data to stadanrize time, dates, geographies.

###### 2.2.2.1.3 Data Accountability
Assing an individual to gover a portion of data. Do not need to be a data eng. could a key user, software eng., product owner. Dont need to solve the problems found, but coordinae for the solution.

##### 2.2.2.1.5 Data Quality
DE shoul ensure data quality by applying data quality tests, data conformance, eschema expectation, completeness and precision. According to "data Governance: the definitive guide" there are 3 main characteristics:
* Accuracy
* Completeness
* Timeliness

###### 2.2.2.1.4 MDM - Master Data Management
Consists on creating a consisten definition of entities such as employees, customers, producst, locations and so on, to be the golden records across the company. As companies scale, this is necessary to avoid different definition on differents areas fo the company. Usually there is a team or person dedicated to it, and DEs should collaborate them on it.

##### 2.2.2.2 Data Modeling and Design
Data Engineers face a wide spectrum of data and must deliver it in an actionable way that users can take insight from it. This is where applying modeling best practices comes to hand. Data ingested and never used generate the famous data swamps.

##### 2.2.2.3 Data Lineage
Data Lieneage describers the recording of an audit trail of data through its lifecycle, tracking both the systems that process the data and the upstream data it depends on. 
* It helps on compliance and lineage of governance data (to know where a row that should be deleted is)
* It has been around for a while, but getting famous as data governance becomes a necessity
* Famous concept: DODD (data observability driuven development)

##### 2.2.2.4 Data Integration and Interoperability
Often DEs need to inegrate different process and sources to operate across different parts od data lifecycle, such as consuming from API, loading to S3, reading via spark API and so on. Ochestration plays a big role in here.

##### 2.2.2.4 Data Lifecycle Management
With the datalake event, it is very common to store all data in the clous since it is cheap. But, to manage data in object oriented storage is not as simple as in DW environments. With incresed GDPR and CCPA rules, deleting user sensible data is a requirement, and this is part of data lifecycle management. ACID Hive and Delta Lake help on this.

##### 2.2.2.5 Ethics and Privacy
In the currents world, avoud data leaks and misusage is also part of DE job. Mask PII, ensure data assets are compliant.

#### 2.2.3 Orchestration
Main responsabilities os orchestration tools:
* Schedule tasks
* Manage or check Dependencies
* Monitor Execution
* Notify desired state
* The choosen tool must be high available

#### 2.2.4 DataOps
Aims to improve release and quality of data products.   
DEs must understand  the tech aspect of building software as well as the data logic used by business and business metrics to create an excelent product.    
DataOps is a set of cultural habits inspired in lean practices. It has 3 core technical elements: Automation, Observability and Moniroting, and Incident Response.

##### 2.2.4.1 Automation
The goal is to enable realiable and consisntet DataOps process, allow quick deploys of features and improvements, via  change management, CI/CD, monitoring and so on.   
Consider a company that only use cron jobs with time schedule. Every time a job runs longer or do no run, next jobs fails. To avoid this, they implement orchestration tool. They still have only 1 instance of the orchestration tool, which lead to breaks when someone deploy new code that is not tested. To solve this they create a dev instance... and so on, they can implement MR system, automated deploy from dev to prod, automated linting, tests...

##### 2.2.4.2 Observability and Monitoring
Wrong data can lead a company to financial problems due to wrong decision, also , DEs sometime just realized something is wrong when the stakeholder complains about a bronke dashboars. Observability, monitoring, logging, alerting, and tracing are all critical to getting ahead of any problems along the data engineering lifecycle. SPC is recommended to implement to monitor events.

##### 2.2.4.3 Incident Response
It is about using automation and observacility to quickly respond to incidents.

##### 2.2.4.4 DataOps summary
The effort of implementing DataOps (DevOps for data) pay off when you can deliver fast products with higher quality, reliable, accurate. Recent tools like airflow have paved the way to data management and lifecycle.

#### 2.2.5 Data Architecture
It defines the long term data strategy and data needs. Architecture are build by gathering business requirements and finding the best architecture cost and effort wise to the company. Data Architect and DEs are usually separate roles, but DE must be able to work on it and give feedback to.

#### 2.2.6 Software Engineering
In early stages DE used to build Map Reduce jobs in C++ and Java. Now, we mostlyt abstracted versions of it in the cloud and usgin higher level coding. There are a few components very important to it.

##### 2.2.6.1 Core data processing code
DEs need to know how to code in SQL, Python ,Spark as well as know best practices, code-testing, unit test, integration, end-to-end and smoke test.

##### 2.2.6.2 Development of open source frameworks
This new generation of open source tools assists engineers in managing, enhancing, connecting, optimizing, and monitoring data. DEs survey for tools to solve problems, keep on eye on TCO (total cost of ownership) associated with a tool. Some open source tool might be availalbe.

##### 2.2.6.3 Streaming 
More complicated than batch. A load of tools to work with, starting by functions for events (lambda, google func, azure func...) and stream processors (spark, beam, flink, pulsar).

##### 2.2.6.4 IaC
As DEs are moving to cloud and managed services, IaC is more common to deploy infra, and also to integrate with DevOps practices as CI CD.

##### 2.2.6.5 Pipeline as Code
DEs use python to declare tasks and create dependencies among them, such as in Airflow. Present in all lifecylcle.