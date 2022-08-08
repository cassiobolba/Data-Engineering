# K8s on Minikube - fast lab setup
video: https://www.youtube.com/watch?v=X48VuDVv0do
repo from video: https://gitlab.com/nanuchi/youtube-tutorial-series/-/blob/master/basic-kubectl-commands/cli-commands.md

## 1. Setu up minikube + virtualbox
This is an alternative way of running docker without using docker desktop, which for business purpose is no longer free.   
For study purpose, you can still use docker desktop.   
Thank to my workmate Sergei that introduced me to the approach below.
* Install Docker
```
brew install docker
brew install docker-compose
```
* Install [VirtualBox](https://minikube.sigs.k8s.io/docs/drivers/virtualbox/)
  
  For Mac users, you might need to allow the oracle machine to run in: system preferences -> security  
* Install [Minikube](https://minikube.sigs.k8s.io/docs/start/).  
* Start cluster using:
```
minikube start --container-runtime=docker --vm=true --driver=virtualbox --memory=2g
```
*Hint: when starting the cluster, you can adjust its settings according to your needs. See the options [here](https://minikube.sigs.k8s.io/docs/commands/start/).*  

* Run the following command in your shell to point it to the minikube's docker environment:
```
eval $(minikube docker-env)
```
* Now you can run docker images:
```
docker run ...
```
* If at some moment you want to stop the cluster (e.g. to free unused resources):
```
minikube stop
```
* Check if minukube is working
```
minikube status
```
If not working delete it and start again

## 2. Kubectl 
Now we have a server installed with minikube and Kubernetes + Kubectl Installed.
Use Kubectl CLI to interact with the kubernetes:
```
# check nodes
kubectl get nodes 

# check pods
kubectl get pod

# check services
kubectl get services

# create a deployment - deployment manages pods
kubectl create deployment nginx-depl --image=nginx

# See the deployments
kubectl get deployment

#  manages the deployment, you should not needed to manage with it
kubectl get replicaset

# edit the deployment file 
kubectl edit deployment nginx-depl
```
Layers of abstraction:
Deployment manage a Replica Set > Replica Set manages Pods > Pos is an abstraction

### 2.1 Debugging an Application
First, lets create a Mongo DB Deployment to check some logs:
```
kubectl create deployment mongo-depl --image=mongo
```
2 usefull functions for debugging:
```
# get the logs of the pod to check waht is happening inside it
kubectl logs {pod-name}

# execute the pod entering inside it
kubectl exec -it {pod-name} -- bin/bash
```

### 2.2 Delete Deployment
```
kubectl delete deployment mongo-depl
```

### 2.3 Configuration File
So far we deployed using few deployments options, but you can specify several configuraions in the deployment command, which would be too hard. Then, k8s have a way to config the deployment via configfiles.yml using the apply command.