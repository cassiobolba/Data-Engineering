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
