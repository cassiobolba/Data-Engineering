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
