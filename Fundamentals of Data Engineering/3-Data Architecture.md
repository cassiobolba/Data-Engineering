## Chapter 3 - Designing Good Data Architecture
### 3.1 What is Data Architecture?
Hard to define as much as is to define DE.   
Lets first understand what is a Enterprise Architecture (Data Arch. fits inside)

#### 3.1.1 Enterprise Architecture
Comprise:
* Business Arch
* Tech Arch
* Application Arch
* Data Arch

“Enterprise architecture is the design of systems to support change in the enterprise, achieved by flexible and reversible decisions reached through careful evaluation of trade-offs.”
*Excerpt From: Joe Reis. “Fundamentals of Data Engineering”. Apple Books.*

#### 3.1.2 Data Architecture
“Data architecture is the design of systems to support the evolving data needs of an enterprise, achieved by flexible and reversible decisions reached through a careful evaluation of trade-offs.”
*Excerpt From: Joe Reis. “Fundamentals of Data Engineering”. Apple Books.* 
Data Achitecture can be divided in 2:
* Operational: What?
    * what are the purposses to use data ?
    * What are the data management constaints?
    * What is the latency requirement?
* Technical: How?
    * How we will move 10tb per h ?

#### 3.1.3 GOOD Data Achitecture
Data architects aim to make significant decisions that will lead to good architecture at a basic level. A good Data Arch comprises:
* Agility
* Flexibility
* Maintainability
* Think of reversability
* Apply the Datalifecycle undercurrents
* Its is living and changing thing and is never finished

### 3.2 Principles of Good Data Architecture
Based on the AWS well-achitected framework and on Google Cloud principles for Cloud Native Architecture, the book brings 9 key points: Choose common components wisely, Plan for failure, Architect for scalability, Architecture is leadership, Always be architecting, Build loosely coupled systems, Make reversible decisions, Prioritize security, Embrace FinOps.

#### 3.2.1 Principle 1: Choose Components Wisely
* choose components tha can be reused by the company and avoid component silos
* things like objecct storage, cloud provider, version tool, observability, monitoring, orchesrtration
* Cloud is perfect for component sharing

#### 3.2.2 Principle 2: Plan for Failure
* At one point, everything fails, should desgin considering it
* Availability: time a component is operable
* Reliability
* Recovery time Objective (RTO): acceptable time for a service of system outage (RTO)
    * a internal report out for a day may cause not problem, but a website out for 5 min could impact
* Recovery Point Obejective (RPO): max acceptable data loss

#### 3.2.3 Principle 3: Architect for Scalability
* Systems should be able to scale up or down, be elastic, ideally in automated fashion
* can also scale to zero, o delete cluster, like serverless
* start simple and go complex in case your system show the  need

#### 3.2.4 Principle 4: Architect is Leadership
* Data ARchitect should spread the word of the selected architecture as a leader to inspire individual workers
* not enforce components, but allow selecction of the best. Cloud offer this flexibility
* architect should enable team to grow and raise their level

#### 3.2.5 Principle 5: Always Be Architecting
* Architect must have great knowledge on current architecture, envision desired arch and plan steps to achieve that
* architects should be agile and collaborative

#### 3.2.6 Principle 6: Build Loosely Coupled Systems
* teams should be designed to code, test, dedploy and change their systems without other teams dependencies
* famous example is the Amazon api system: ALL team communications are made via API
* Properties of loosely coupled systems:
    * broken in small components
    * communications via API or similar
    * point 2 enables system to evolve without disruption in the interface
    * no waterfall release, each system evolve separately

#### 3.2.7 Principle 7: Make Reversivble Decisions
* Data landscape changes quickly
* be prepared to move and change architecture

#### 3.2.8 Principle 8: Prioritize Security
* Every DE help on security build and maintenance
* Use zero-trust approach or shared resp. security model

#### 3.2.9 Principle 9: Embrace FinOps
* manage costs can be tricky on cloud environment
* DEs must know cost system an how to optimize and choose the best
* It evolves the operational monitoring model to monitor spending on an ongoing basis
* Data FinOps is a new area and have good territory!

### 3.3 Major Architecture Concepts
#### 3.3.1 Domains and Services
A domain is the real-world subject area of which you are architecting.   
A service a set of functionality whose goal is to accomplish a task.   
A Domains contains multiple services.   

#### 3.3.2 Distributed Systems, Scalability, and Design for Failure
* Design for scalability
* Elasticity
* Availability
* Reliability
* Distributed systems can help on all these by providing these characteristis to the cluster or service you use
* Cloud services usually provide it under the hood

#### 3.3.3 Tight Versus Loose Coupling: Tiers, Monoliths, and Microservices
* Tight Couple systems: most pieces depend on each other, centralized
* Loosely couple systems: Distributed, no dependencies, easy to change

##### 3.3.3.1 Architecturse Tiers
Applications have layers like data, app, business logic, presentations... You need to know how to decouple them to make it flexible and no monolithic.   

###### 3.3.3.1.1 Single Tier
* Every layer lives in the same server (database and application for example). 
* It is good for development, not for production. 
* All layers share the same resources, making hadr to optimize

###### 3.3.3.1.2 Multitier
Aka n-tier is hierarchical layers, separating database from application, and from presentation... 
* 3-tier is very famous for client server desgin.
* start simple and increse tiers as needed

##### 3.3.3.2 Monoliths
* Includes as much as possible under one roof
* Can be Tech coupled or Domain coupled, or together
* Very hard to mantain and upgrade

##### 3.3.3.3 Microservices
* Separate, decentralized and loosely coupled services
* Each service has its own function and do not depend on the other
* Breaking a monolith to microservices is very hard and sometimes impossible

##### 3.3.3.4 Considerations for Data Architecture
* Above we saw many soft. eng. concepts that are being recently implemented to DE teams
* A loosely coupled Data Architecture would have its pipelines and DW split by domain, for example, sales and inventory run independently

MONOLITH X MICROSERVICES PIC

* But it does not resolve the complexity of sharing domains data
* If DWs from sales and inventory are separate there are options to make a user have good access to both:
    * centralization: a team is responsible for centralizing all domains data and curate it
    * data mesh: each SE team is responsible for delivering usable data

#### 3.3.4 User Access: Single vs Multitenant
* Consider 2 factor for it: performance and security
* Very common approach is to isolate tenant data in views
* Consider if the data shared is secured enough and only needed people will have access
* If sharing the same tenant data (or view) with many users, consider if performance is not being affected by high usage

#### 3.3.5 Event-Driven Architecture
An event-driven workflow encompasses the ability to create, update, and asynchronously move events across various parts of the data engineering lifecycle.
* it enables to save the events state and recover easily
* example of loosely coupled, that events pass throught loosely services

#### 3.3.6 Brownfield vs Greenfield Projects
##### 3.3.6.1 Brownfield Projects
* Involve refactoring an existing system
* Need to undersdant the current architecture
* Why decisions were made ?
* Use empathy, identify opportunities and pitfalls
* Common pattern is the strangled pattern: slowlly releasea updates and switchs to new architecture, small steps that allow rollback

##### 3.3.6.2 Greenfield Projects
* Start a project from zero
* The pitfall is to be more excited about usgin new shiny tech than focusing on bringing value
* Be flexible, aim positive ROI, access tools trade-offs

### 3.4 Examples and Types of Data Architecture
Most common Architectures
#### 3.4.1 Data Warehouse
* Central Hub for reporting and Analysis
* Oldest type of Architecture
* Gained even use because new cloud DW with pay as you go methods
* Divided in Organizational and Technical
    * Organizational
        * Analytics Process (OLAP)
        * better performance for analisys
        * Centralize and organize company data
    * Technical
        * Supports MPP to process massive amount of data
        * Started with row based process, now changing to columnar based to incresve even more the capabilities

##### 3.4.1.1 The Cloud Data Warehouse


# order
## -> chapter x 
### -> RED 
#### -> bold 
##### -> grey
###### -> italic

<div><img src="link" style="height: 400px; margin: 20px"/></div>