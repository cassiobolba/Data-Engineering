## 1. Introduction
* Kubernetes is the most orchestrations engine
* Can be used in the main cloud providers
## 2. Cluster Architecture
OFFICIAL DOCS: https://kubernetes.io/docs/concepts/overview/components/

IMAGE

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