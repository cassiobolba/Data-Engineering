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
* Software Engineering
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
**Data Architect**
* Data architects design the blueprint for organizational data management, mapping out processes and overall data architecture and systems
* Experienced person bridging tech to non tech people 
* Depending on the maturity stage of a company, a DE can take the responsabilities of data architect, thus need to know the best practices
**Software Engineers**
* Build softwares that are usually the internal data consumed by DE (data, events, logs...)
* Good practice is that SE and DE align ideas when a data project is about to born
* Coordinate with SE the application type, volume, format, frequency of data
**DevOps Eng and SRE**
* Usually produce monitoring data

##### Downstream Stakeholders
**Data Scientist**
* DEs should deliver good quality data to DS and enable path to production
**Data Analysts**
* They are usually experts in a domain
* DEs deliver data pipelines to enable analysis
**ML and AI Engineers**
* As before, deliver good data
* May help to deploy stuff to production

#### Data Engineers and Business Leadership
