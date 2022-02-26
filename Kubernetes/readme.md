# DAY 1
## 1. Introduction
* Kubernetes is the most orchestrations engine
* Can be used in the main cloud providers
## 2. Cluster Architecture
OFFICIAL DOCS: https://kubernetes.io/docs/concepts/overview/components/

https://github.com/cassiobolba/Data-Engineering/blob/master/Kubernetes/img/kubernetes-architecture.png

### 2.1 Master Node - Control Plane
* Set of working machines
* Distributed Architecture ( master - slave , like kafka, spark...)
* All features in the master nodes are called CONTROL PLANE

* API SERVER: Front end server handling API requests, receive
* ETCD: Db handling metadata
* **SCHEDULER** : Do reconciliations loops, monitoring the states of pods, requests for new pods. Read data drom etcd
* CONTROLLER:
    * Kube Controller: Control deployments of local dependencies. monitoring the states of pods with the scheduler. Read data drom etcd
    * Cloud Controller: Same as Kube, but for cloud resources

* Usually

### 2.2 Worker Nodes
* Run pods and applications
* KUBELET: Agent running on each node, check container health
* KUBE-PROXY: Route network request between pods and internet
* CONTAINER RUNTIME: DOCKER IS HERE, start and stop containers
* KUBECTL: CLI interacting with 

### 2.3 Pod
* Pod is the minimm unit in Kubernetes
* Ephemero
* Auto create a new replica to continue application
* Pods are created usgin manifest in yaml or json
* A worker can have multiple pods
* Can be in 5 phases
    * Pending
    * Running
    * Suceeded
    * Failed
    * Unknown

### 2.4 Workloads
* Are pod controllers
* take care of pods
* there are 4 kinds

#### 2.4.1 DaemonSet
* create one pod per node only
* 5 workers, 5 pods
* used mostly for log control
* deploy of monitoring applications to collect data from all nodes
* Cant scallate without add node
* Epehemal - stateless 

#### 2.4.2 Deployment & Replicaset
* Specify how many identical pods I want
* Specify number of replicas
* Scheduler distributes replicas on workers
* Workflow:
    * User update manifest increasing number of pods
    * it is saved on etcd db
    * controller checks and see the update
    * Controlled tell scheduler to apply the changes
    * Scheduler check lots of rules to distribute the pods on the nodes
    * can happen all pods on same worker node
* Used for real life applications
* Epehemal - stateless 

#### 2.4.3 StatefulSet
* Pods with stick ids
* Create persited volume to save date
* MySql, Mongo and other dbs are deployed like this
* Specify storage class to store volume
* Specify replicas also
    * if 3 replicas, 3 times the same data

#### 2.4.4 Job
* run job for specific times
* ex. Run 10 times

#### 2.4.5 Cron Job
* run job for specific schedule
* example: every 15 minute read a file from blob storage

## 3. Service
* Abstract exposure of an application, running on a set of pods as Network service
* Expose a service in External API address, out of Kubernetes Cluster for Internet access
* Pods receive IP adresses and single DNS name
* kind: service
* External user access the cluster via kube-proxy that redirect to cluster IP

### 3.1 Service Type
* ClusterIP 
    * kind : Service 
    * Communication between incoming traffic and pods
    * Only inernal traffic
* NodePod
    * Open ports to external traffic pods
    * Not so used
    * Not to external access
* LoadBalancer
    * Provided by clouds
    * Paid
    * Most used
    * To pusblish applciations to external

## 4. Ingress
* Manage external access to services in a cluster
* usually HTTP request
* Provides LB, SSL and name-based virtual hosting
* Lives on worker nodes
* Ingress providers:
    * Nginx
* Cons:
    * Can be hard to control

## 5, Volumes and Types
* Pod creates a folder called empty dir to store info and share with other pods
* When pod restarts it clean state
* Destroyes ephemeral volumes
* To save volume and persist data after restart, can assing a persistent volume
* The volume types can be
    * Azure disk
    * Google Persistent Disk
    * AWS EBS
* Kubernetes created  CSI - Container storage interface to facilitate the creationg of volumes
    * It also enables dynamic provisioning

## 6. Configuration - ConfigMAps and Secrets
### 6.1 ConfigMaps
* Store non-confidential data in key-value
* Consumed as variables, CLI arguments or config files in a volume

### 6.2 Secrets
* Sensitive info
* Pass and user
* Tokens
* stores outside of applciation code

## 7. Kubernetes Infra
### 7.1 Self hosted Kubernetes
* Deployed usually on-premisses Envs
* Hard to mantain and implement
* have to create clustes, load balancer, bkp, mantainance, CI/CD integrations, isoaltion
* Twitter tried to do it, and failed spending millions

### 7.2 Kubernetes as Managed Service
### AKS - Azure
* Control plane is free
### GKE - Google
* pay 10 cents / h control plane
### EKS - Elastic - Amazon
* pay 10 cents / h control plane

## 8. IaC for DE
* Managed and provision Resources usign code to reduce mnaul process
* Immutable Infra approach
* Pros
    * speed and safety
    * documentation
    * version control
    * validation
    * reuse
* Terraform is the best

### 8.1 Terraform
* Created in Go
* Open source IaC
* Have Terraform Registry
    * Repository of code to deploy infra
    * Choose what and where to deploy

## 9. Kubernetes for DE
* Kubernetes is already used for apps as de facto structure
* Since 2018 it is comming to Big Data (3rd generation of big data)
    * Solve cost that cloud platform promissed to reduce but usually did not
    * Scalling
    * Microservices oriented
    * statefulsets
* Cons
    * Pipelines can take a bit more time due to ephemeral concepts
    * Steep learning curve

## 10. Storages
### 10.1 SC - Storage Class
* Comes from main Cloud provider
* They offer usually HDD and SSD disks
    * it affect the speed and cluster quality
* Examples
    * AWS EBS
    * Azure disk
    * Google Persistent Disk

### 10.2 PV - Persistent Volume
* Kubernetes dont see SC, just PV
* It translate the SC to the PVC
* Volume plugin to each provider

### 10.3 PCV - Persistent Volume Claim
* Request storage by user
* Consume PV resources
* Claim sizes to mount
* Claim to PV, then PV ask SC to see if it is possible to mount the volume claimed
* Pod main entry coomunication

## 11. StatefulSet
* Manage statedul applications on Kubernetes
* Provides Guarantees about ordering and uniqueness of pods
* StatefulSets request via PCV to PV a volume., PV then checks id SC is available

## 12. Develpment Enviroment
* Local (virtualizadores)
    * Minikube
    * Kind
    * K3D
* CLoud
    * Digital Ocena - https://try.digitalocean.com/freetrialoffer/
    * Linode - https://www.linode.com/lp/free-credit-100/

### 12.1 Kubernetes Env packages
* Manage complex manifests usign tools to reduce complexity and enhancing development experience
* HELM
    * Package manager for kubernetes
    * manage applications using charts
    * Define, Install and upgrafe complex manifests (YAML)
* KUSTOMIZE
    *  Similar to Helm
* ARTIFACT HUB
    * new version of helm hub
    * repository of helms
* SOURCE CODE REPOSITORY
    * Git hub
    * Git CI
    * Bit bucket
* CONTAINER REGISTRY
    * Dockerhub
    * Git lab container Registry
    * Amazon ECR
    * Google container Registry
    * Amazon container Registry

### 12.2 Tools for DE on Kubernetes
* CLI
    * KubeCTL
    * KubeCTX
    * Kubens
* LOG AND TROUBLESHOOTING
    * Stem
* ADMIN AND MAINTENANCE
    * Kube forwarder (SSH Tunnel)
    * K9s
    * Lens

# DAY 2 
## 1. Big Data Stack
### 1.1 Cloud managed Services
* IaaS, PaaS and SaaS
* Enterprise Support
* Pays as you go - no upfront cost
* Managed Infra by cloud provider
* Small Teams - easy collaboration, DevOps, autonomus, sutomatic
* Latest versions - updated by cloud provider
* Business Oriented
* AWS, Azure, GCP

### 1.2 Open Source Solution - OSS
* Best Big Data technologies are open source - or derived
* Save on licenses
* Community
* Use ope source in cloud services engine
* No lock in

### 1.3 Big Data Products Overview
#### 1.3.1 DataLakes
* Azure Blob
* S3
* google Cloud Storage
* minIO
#### 1.3.2 Ingestion
* Event Hubs
* AWS Kinesis
* Pub Sub
* Kafka
* Apache Pulsar
#### 1.3.3 Processing
* Synapse Analytics
* AWS glue
* Dataflow
* Apache Spark
* KSQLDB - realtime with sql
#### 1.3.4 Serving
* Synapse
* Redshift
* Big Query
* Apache Pinot
* YugabiteDB
#### 1.3.5 Data as a Product
* PBI
* Quick Sight
* Data Studio
* Superset
* Metabase

## 2 Cost Comparison
Compare kubernetes based big data architecture x services offered by Azure and aws.
Not compare with google serices because they may be cheaper than usign kubernetes. 
### 2.1 Cost on AWS and Azure
* Considering 1TB
* Storage Layer: 2.5k reais
* Processing Layer( 3 zones): 6.5k
* Serving Layer DW: 14.5 k reais
* Total: 23.5 k reais
### 2.2 Cost oin Kubernetes
* Considering 1TB
* Storage Layer, considering more layers
* VM general purpose
* 4 vcpus with 16gb ram each
* 6 vms
* 730hs month
* Use kubernetes managed by a cloud provider
* Total: 7k reais - 3x less

### 2.3 Decision Points
* Business must be alligned with the approach of kubernetes
* team must be aligned and wanting to learn
* budget: work to reduce current cost can be better than build something new and a starting point
* Automate and reduce complexity
* Sight of the future: companies need to know what is the future -> KUBERNETES

## 3. Declaritive GitOps CD
* Reduce manual work
* Practices taht empower developers to perform tasks for CI CD lyfecycle process
* CI CD is inside DevOps practices
* CI
    * Increase speed of deploy
    * ensure quality
    * Continuous commit
    * Git repository
* CD
    * Deliver to prod at any time
    * produce software in short cycle
    * automatic deployment
    * build, test and release
* Tools to use
    * Argo
    * Jenkins
    * Git CI

### 3.1 CD with ARgo CD
* Declarative GitOps tool for kubernetes
* Applucation Deployment and lifecyle Management
* Argo will at every 3minutes look for changes in the master branch to apply

### 3.2 Big Data Products Deployment Workflow With Argo
* Use namespaces
* It is a logical organization in kubernetes
* FOLLOW THIS README /Users/cassiobolba/Downloads/Big Data on k8s/repository/readme.md
* VIDEO -> around 01:30
* connect to clusters
    * cluster was deployed to cloud via teraform
* create namespaces
* download argo
* install argo via helm
* create load balancer to get eternal IP
    * Cloud controller will request
* when list the cluster (workers or pods?) will see one with external ip
* this ip is used to acess argo interface
* then get argo passwrod that is randonly generated
* create role binding for admin
* register a cluster
* register a repository to look for changes 
* on helm charts folder we find all the helms downloaded from helm repository
    * this is good to keep working version before reading a new file from repository with not tested changes

## 4. Apache Kafka
### 4.1 Backbone System for distributed events
* Create events and send to kafka - Producers
* Import data as events from DB with connectos - P
* Create query events and tabels with KSQL - Consumer
* Read and priocess events - C
* Export data as events with connectors - C
    * Migrate data/synch data between DBs

### 4.2 Components & Architecture
* Topic
    * like a table
    * replication factor = replicate the topic to other brokers
    * Horizontal partition for writes
* Kafka broker = server or node, orchestrates the storage
* Cluster = group of brokers
* Partition Leader = handles all produces requests, receives the writes
* Partition Follower = Replicates the parittion data from leaders
* Producer = applciation in your that creates data
* Consumer = application that read data
* Consumer Group 
    * ex: we have a topic with 3 partitions
    * we can have a group of consumer with 3 conusmers reading the same topic
    * Kafka will redirect each consumer to a parition
    * if a 4th consumer is added, it will be idle until a new parition is added
* 1 parition can handle until 700k resquest per minute, enough for most of bunises 

### 4.3 Kafka on Kubernetes with Strimzi Operator
* Best way to run kafka on kubernetes in various deployments flavours
* this is a group of operator that work within kafka
    * cluster operator
    * entity 
    * topic
    * user
* It is deployed in kubernetes as a kind : strimzi
* Operator works as conciliations loops
* Integrates autoamtically with statefulset
* Brings Storage types
    * epehemeral
    * persistent
    * JBOD
* Listener types - how clients connects to a kafka cluster
    * Route
    * Load Balancer
    * Node Port
    * Ingress
* Security Option - Perform secure deployment of kafka on kubernetes
    * ACLs
    * OAuth
    * aTLS

#### 4.3.1 Install Strimzi - kafka
* FOLLOW THIS README /Users/cassiobolba/Downloads/Big Data on k8s/repository/readme.md
* Line 64
* VIDEO -> around 02:40
* steps
    * add repo strimzi
    * install helm do kafka-strimzi operator
    * deploy config maps - to export metrics to grafana and prometeus
    * Install components
        * use the app-manifest to deploy, then argo will manage using git ops
        * the app manifest tell the path where argo will find the yaml yo deploy kafka-broker or kafka-connector for example

## 5. MinIO
* Kubernetes Native multi-cloud open source Object storage
* Available in public, hybrid and Private cloud