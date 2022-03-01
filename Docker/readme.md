# Docker Studies Notes
## Use docker With minikube + virtualbox
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

## Docker Commands
```py
# run a container
docker run <image name>

# list all container running
docker ps

# list containers running and ran previouslly
docker ps -a

# stop container
docker stop <container name or id>

# recomer container 
docker rm <image name>

# list docker images downloaded
docker images

# delete an image
docker rmi <image name>

# pull image without running
docker pull <image name>

# run a container in background mode
docker run -d <container name>

```
