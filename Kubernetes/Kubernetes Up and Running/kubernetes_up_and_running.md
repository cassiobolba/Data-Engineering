# Kubernetes Up and Running
official  [repo]('https://github.com/kubernetes-up-and-running')

## 1. Introduction
First chapter enphasize the mais concepts od kubernetes and why it is changing the way developers are working by highlighting the most important improvements this technology brought to teams.
* Velocity   
    * The Value of Immutability   
    * Declarative Configuration    
    * Self-Healing Systems   
* Scaling Your Service and Your Teams    
    * Decoupling   
    * Easy Scaling for Applications and Clusters   
    * Scaling Development Teams with Microservices   
    * Separation of Concerns for Consistency and Scaling   
* Abstracting Your Infrastructure   
* Efficiency

## 2. Creating and Running Containers
* Kubernetes is meant for creating, deploying and managing distributes applications in containers
* Applications are generally comprised of a language runtime, libs and the code
* Traditional method of running multiple programs in same server OS can have troubles dealing with dependencies
* Previous chapter immutability is a big advantage to solve this problem
* Docker helps on building, packing and sharing images
* Docker is the most common  image format, other is OCI

### 2.1 Container Image
* It is a binary package of a container technology (like docker) that encapsulates all files necessary to run a progrma in an OS
* This image can be built locally or pulled from a container registry (like docker hub)
* Container images are constructed with a series of filesystem layers, where each layer inherits and modifies the layers that came before it 
* One conatiner image can be based on other image, and so on
* 2 types of containers:
    * System Containers -> try to mimic a full syste, such a vm does (no longer used that much)
    * Application container -> runs a single program offering the right granularity of isolation and easy scalability

### 2.2 Building Images with Docker
We will use an application container approach to build a image. Install docker

#### 2.2.1 Dockerfiles
* Build the folder directory as folder 2
* do via command line to folder  2
* run
    * docker build -t simple-node .
    * docker run -rm -p 3000:3000 simple-node