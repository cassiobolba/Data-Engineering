# FUNDAMENTALS OF DATA ENGINEERING
*THESE ARE NOTES FROM THE BOOK, FOR FURTHER CHECKS.*   
"we unapologetically take a cloud-first approach. We view the cloud as a fundamentally transformative development that will endure for decades; most on-premises data systems and workloads will eventually move to cloud hosting. We assume that infrastructure and systems are ephemeral and scalable, and that data engineers will lean toward deploying managed services in the cloud".  

## CHAPTER 1 - Foundation and Building Blocks
### Definition of DE
“Data engineering is the development, implementation, and maintenance of systems and processes that take in raw data and produce high-quality, consistent information that supports downstream use cases, such as analysis and machine learning. Data engineering is the intersection of security, data management, DataOps, data architecture, orchestration, and software engineering. A data engineer manages the data engineering lifecycle, beginning with getting data from source systems and ending with serving data for use cases, such as analysis or machine learning.”

Excerpt From: Joe Reis. “Fundamentals of Data Engineering”. Apple Books. 

### A bit of history 
*(in my words, a summary).*   
* In earlies 70 the web systems needed sources to store the bom o web based application, then databases raised faster
* Around 80's wiht the need to analyze it, Kimbal invented the famous DW concept (widely used today). This also brought up the term BI Engineer, ETL developer and so on
* 90's brought the big data term due to internet + web applications generating massive amount of data, opnening space for companies like google, yahoo and amazon to emerge on it
* 90's boom is also a stater for yahoo engineers create the Apache Hadooop and map reduce system
* In the next years, Big Data Engineers were basically too focused on mantaing these infrastucture, which were very technically hard to do, and expensive
* Now a days mostly of the complexity of these distributed system are abstracted under the hood by cloud providers and reshaping the term Big Data Engineers, to Data Engineers
* A nice new concept: Data Lifecyle Engineers is brought by this book, which I really feel like what I do now!

### Data Engineers Skill Set
Ultimately in simple words:
* Security
* Data Managements
* Data Ops
* Data Architecture
* Software Engineering.  
There is a company factor that cat drastically change how DE use the above skills and how their carrer progress, and it is **DATA MATURITY**

### Data Maturity
“Data maturity is the progression toward higher data utilization, capabilities, and integration across the organization”

Excerpt From: Joe Reis. “Fundamentals of Data Engineering”. Apple Books. 

There are many maturity models, such as DMM and other, but might be hard to decide and choose one. Then, this book created a simple data maturity model in 3 steps:   
**STARTING WITH DATA** >> **SCALING WITH DATA** >> **LEAD WITH DATA**.  

#### Starting With Data
Companies at this stage have no data maturity but want to. Data Engineers in this stage companies are usually generalists and perform a wide variety of tasks. Advices for this step:
* Find sponsors and stakeholders that want to buy the idea of being data driven. Someone need to support the architecture and ideas you develop
* Define the right data architecture to solve the problems you aim to and bring some value for the company
* Identify and audit data that will support key initiatives and operate within the data architecture you designed
* Build a solid foundation for data reporting and data science use it. In the begginin very likely you will be creating reports =P
In this stage, many pitfalls and traps will be present, some advice on it:
* Organization will want quick return from data initiatives. So, build som quick wins to show value but be aware that quick wins usually brings tech debt. Have a apla to reduce it and dont mess with future developments.
* Get out and talk to stakeholder and check if waht you are creating, brings real  values, to avoid building data silos that are unused.
* Avoid technical complexity, use simple tech stack unless it brings much more value. Custom code and solution should be used only it creates exceptional value.
* It is not forbiden to already have DS and AI projects, but is very likely to fail do to the lack of maturity.

#### Scaling With Data
At this point companies moved away from ad hoc stuff, and now have a structured data team. DE are more speciallist than generalist. The goal is to plan and develop a scalable structure to allow a future data driven company. Focus on:
* Establish formal data practices
* Scalable and robust architecture
* Adopt DevOps and DataOps practices
* Build the systems to suport ML
* Continue avoiding heavy lifting and customized tools, only if brings a great result
There are also issues to watch out:
* In this stage, there is always the temptation to adopt "silicon valley cutting edge tooling" like. Avoid unless really benefitial.
* The main bottleneck for scaling is not cluster nodes, storage, or technology but the data engineering team. Focus on solutions that are simple to deploy and manage to expand your team’s throughput
* DATA LITERACY: Dont act as a data god. Focus on pragmatic leadership to transition to next stage. Communicate even more with other users and stakeholders and teach the organization how to consume the data.

#### Leading With Data
Now, you are a data-drive company. Automated pipelines run easily and allow company to do a self-service analitycs and ML. DE implemented controls, monitoring and practices to ensure data availability and quality. DE's are more and more speacialist than ever:
* Create seamless introduction of new data to allow better analysis
* Build custom tools that leverage data competitive advantage
* Adopt Data Management, governance, quality, and dataops
* Adopt tools to disseminate data in the company -> Data Catalog, data lineage and metadata management
* Collaborate with ML, Software Eng, analysts
* Create a data community to share and talk with pepole openly
Watch out for the following issues:
* Do continuously maintenance and improvements to not risk fall back to stage 2
* Temptation to try and spend time on ndistractions are really high at this point. Just do what clearly bring benefits to the company

### The Background and Skills of a Data Engineer
Since it is a new area, we lack a formal learning path as universities so expect to study many topics by yourself, or take niche focused courses and bootcamps to fill some gaps. People transitioning from ETL developers, BI, Data Science, Software Eng. and other data aware fields, tend to have a smother transition.

#### Business Responsabilities
There are a vast broad amount of responsabilities a DE can have and a short summary would be (it does not mean you must do all):    
* Know how to communicate with nontechnical and technical people.
* Understand how to scope and gather business and product requirements.
* Understand the cultural foundations og Agile, DevOps and DataOps
* Control Costs
* Learn Continuously and filter what is a good or not technology to try

#### Technical Responsabilities
You must be able to design and mantain the data architecture and is components, and use the DE lifecycle topics such as:
* Security
* Data Management
* DataOps
* Data Architecture
* Software Engineerging
Then main languages used as of now:
* SQL - interface with databases
* Python - state of the art in languages for data roles
* JVM Language - Tend to be more performatic tahn python. Know Java os Scala can be nice
* Bash - CLI for Linux systems (powershel for win users)

#### The Continuum of Data Engineering Roles, from A to B
Appears that a DE is a unicorn with all data knowledge, but in fact you do not need to be that person. In DS there is a disctinction of DS A and DS B professional (analist and builder), translating this to DE:   
**Type A - Abstraction DE**. 
Keep the Data Architecture as abstract as possible by using off-shelf products and managed services and tools. They can work on companies in all levels of maturity.
**Type B - Builder DE**.    
They build tools and systems that scale and leverage data on the company, usually with Software Engineering backgrounds, they are found mostly in companies migrating from stage 2 to 3 in our data maturity scale.

### Data Engineers Inside an Organization (RED)
#### Internal-Facing Versus External-Facing Data Engineers
The *External DE* deal with APIS, external integrations, social media, IoT and ecomerce. They need to deal with extra components such as higher security, latency, limits os queries, concurrency and so on, in addition to normal requirements they have from their internal stakeholders.
The *Internal DE* usually deals with more straightforward tasks such as ETL, reports, BI dashboards, DW and so on.
Usually the 2 types of user facing are mixed and the internal work is usually also a pre-requise to external works.

#### Data Engineers and Other Technical Roles (BLACK)
DEs are a hub between Data Producers such as SE, DA, DevOps or SREs, and Data Consumers such as Data Analyst , DSm DEs and  ML.

##### Upstream Stakeholders (GREY)
You Must understand the data Architecture you use as much as understand the type of data and source systems producing the data. Let's take a look at each upstream role.
* Data Architect
  * Data architects design the blueprint for organizational data management, mapping out processes and overall data architecture and systems
  * Experienced person bridging tech to non tech people 
  * Depending on the maturity stage of a company, a DE can take the responsabilities of data architect, thus need to know the best practices
* Software Engineers
  * Build softwares that are usually the internal data consumed by DE (data, events, logs...)
  * Good practice is that SE and DE align ideas when a data project is about to born
  * Coordinate with SE the application type, volume, format, frequency of data
* DevOps Eng and SRE
  * Usually produce monitoring data

##### Downstream Stakeholders
* Data Scientist
  * DEs should deliver good quality data to DS and enable path to production
* Data Analysts
  * They are usually experts in a domain
  * DEs deliver data pipelines to enable analysis
* ML and AI Engineers
  * As before, deliver good data
  * May help to deploy stuff to production

#### Data Engineers and Business Leadership
DE also interact with Business pepole, not only tech stakeholders:
* CEO: Align with senior DEs and Data Architects what are the possibilities with data
* CIO: (information) This person is highly technical and business oriented and makes strategical decision on IT elements sucha as ERP, CLoud Provider, CRM, migrations...
* CTO:
* CDO: Created in 2002 in capital one to give a better importance to data, they are responsible to implement data strategy, core functions , data privacy and management.
* CAO: (analytics) Can exists to take speaciall care of BI, AI, and ML.
* Product Managers: The owner of a initiative / product 

## CHAPTER 2 - The Data Engineergin Lifecycle
### What Is the Data Engineering Lifecycle?
This comprises all stages needed to deliver a data product ready for comsumption by downstream stakeholder. Main steps are: Generation, Storage, Ingestion, Transformation and Serving Data.
[PICTURE LIFECYCLE]. 
#### The Data Lifecycle Versus the Data Engineering Lifecycle
**DE Lifecycle:** It is just a subset of Data Lifecycle.  
**Data Lifecycle:** All data lifespan from source system where DE have no control until de BI dashboard.
#### Generation: Source Systems
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

#### Storage
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

##### Understanding data access frequency
Determine if you data is hot (very often accesed) or cold (mostly not frequently used and mostly archived for auditions). This have a very big impact on cost and the speed of access.

##### Selecting a storage system
Selecting the right storage depeneds on each use case, sucha as volume, drequency of ingestions, format, size and other. There is no unique solution for all cases, and there are countless technologies. More in chapter 6.

#### Ingestion
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

#### Transformation
Now data need to be transformed to start bringing value for downstream user. Key considerations for transformation phase:
* What’s the cost and return on investment (ROI) of the transformation? What is the associated business value?
* Is the transformation as simple and self-isolated as possible?
* What business rules do the transformations support?
* Am I minimizing data movement between the transformation and the storage system during transformation?   
Transformations can happen in batch or streaming, depending the case. Transformations are one of the toughest parts of data lifecycle. Business Logic is the driver of this stage, because this is what might bring value to end user and allow analysis of current status, reporting and ML. Data featurign is also a big part of it, and requires a DS to analize the data and discover the main features for ML and tell DE to implement that automatically in the data pipeline.

#### Serving Data
The last step after data being collected and transformed, is the step to bring more value from the data. Hopefully at this point the data you are serving is really being used for a purpose, otherwise it will be a wasted pipeline. If data is used, this is where the magic happens: ML can apply forecast, analysts can find oportunities in the data and so on. Let’s look at some of the popular uses of data: analytics, ML, and reverse ETL:

##### Analytics
The main purpose of ETLs normally. Currently divided in 3 facets:
* Business Intelligence: The data you applied business logic is now used to create reports, dashboards and on. Now a days there is also the new Analytc role that cerate a repository of business logic using the raw data you ingested (DBT use by analytis engineers). As the data maturity grows in the company, enabling self service analytics tends to happens. The biggest challenges of self-service analytics are poor data quality, data silos and lack of adequate skills from users perspective.
* Operational Analytics: Details of operations usually near realtime, such as live inventory data, healt monitoring of web pages, and so on. Intended to be real time to react upon it.
* Embedded Analytics: This is when you provide analytics to external cutomers in a platform. Security, data management, trust, permissions and volume of access are much more critical than internal analytics solutions. DEs can use for this multitenancy views which are a set of views containing only data for a specific user, consuming from a mains source which contains all data.
* 
##### Machine Learning
Companies with good maturity can tackle problems with ML. DEs usually help ML and Analytics engineers to set up environment, implement data catalag, lieneage and so on. DEs also support implementation of feature stores for ML engineers. Key considerations when serving data to ML:
* Is the data with sufficient quality? Align with users
* Is data discoverable?
* Where are tech and org. boundaries between a ML and Data Engineer?
* 
##### Reverse ETL
The practice of taking curated data and feed into SaaS and other platforms, and sometimes ingesting it again. Ex. Marketing team read bids for a data, analyize, change and re-upload it again to biding platform.

### Major Undercurrents Across the DE Lifecycle (red)
As DE evolved, new practices other than just ETL have been incorporated to the role, such as the undercurrents: Security, Data Management, DataOps, Data Architecture, Orchestration, Soft. Eng. :

IMAGE

#### Security
This should be top priority, and the concept of least privilege must be used. Give only the inteded access necessary to the tuser execute the task. You also should not have usperuser or admin access all the time. It avoid accidental damage. Use encryption, tokenization, masking, obfuscation and mantain a simple and robust access control.

#### Data Management
Data best practices once reserved for huge companies—data governance, master data management, data-quality management, metadata management—are now filtering down to companies of all sizes and maturity levels. Data management practices form a cohesive framework that everyone can adopt to ensure that the organization gets value from data and handles it appropriately. Data management has quite a few facets, including the following:
* Data governance, including discoverability and accountability
* Data modeling and design
* Data lineage
* Storage and operations
* Data integration and interoperability
* Data lifecycle management
* Data systems for advanced analytics and ML
* Ethics and privacy

##### Data Governance
According to Data Governance: The Definitive Guide, “Data governance is, first and foremost, a data management function to ensure the quality, integrity, security, and usability of the data collected by an organization. This is key to ensure data is realiable and is being used in the right way. Main categories of data governance are discoverability, security and accountability.

###### Data Discoverability
End users should be able to find the right data, know where it comes from, how it relates tp pther data and what the data means. Key areas of dicoverability are metadata management and masterdata management:

###### Metadata
Is data about data. There are several automated tools to generate them, but human aspect should no be taken off because it has more knowledge on the area to add. Can come from 2 sources, auto generated and human generated. Wikis are important tools and should contain data experts, sources, owners, consumers, and it is human generated. But it also should be connected to automated tools. DMBOK divides the metada in 4 categories:
* Business Metadata: Identifies businees logic and definition. DEs would consult data catalogs or dictionary to for ie. know the definion of customaer to generate a nes costumer segment table. Is customer who have ever bought or only who bought on the past 90 days.
* Technical metadata: Data created and udes by systems such as data model and schema, lineage, field mappings, and pipeline workflow. 
 * Pipeline metadata show dependencies, schedule, configs, connections and more
 * Lineage metadata tracks origins, dependencies and data changes over time. Provide audit data
 * Schema metadata manages columns for dw, o other data for object store
* Operational metadata: statistics, , job ids,runtime logs, error logs and on.
* Reference Metadata: Data used to classify other data, like look up data to stadanrize time, dates, geographies.

###### Data Accountability
Assing an individual to gover a portion of data. Do not need to be a data eng. could a key user, software eng., product owner. Dont need to solve the problems found, but coordinae for the solution.

###### Data Quality
DE shoul ensure data quality by applying data quality tests, data conformance, eschema expectation, completeness and precision. According to "data Governance: the definitive guide" there are 3 main characteristics:
* Accuracy
* Completeness
* Timeliness

###### MDM - Master Data Management
Consists on creating a consisten definition of entities such as employees, customers, producst, locations and so on, to be the golden records across the company. As companies scale, this is necessary to avoid different definition on differents areas fo the company. Usually there is a team or person dedicated to it, and DEs should collaborate them on it.

##### Data Modeling and Design

