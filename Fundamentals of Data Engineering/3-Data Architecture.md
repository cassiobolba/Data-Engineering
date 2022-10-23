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
* Use zero-trsut approach or shared resp. security model

#### 3.2.9 Principle 9: Embrace FinOps
* manage costs can be tricky on cloud environment
* DEs must know cost system an how to optimize and choose the best


# order
## -> chapter x 
### -> RED 
#### -> bold 
##### -> grey
###### -> italic

<div><img src="link" style="height: 400px; margin: 20px"/></div>