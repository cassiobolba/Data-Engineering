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

## Docker Basic Commands
```py
# run a container
docker run <image name>

# list all container running
docker ps

# list containers running and ran previouslly
docker ps -a

# stop container
docker stop <container name or id>

# remove container 
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

## More run Commands
```py
# run specific version of a container with TAG
# the :4.0 is the tag for the specific version
docker run redis:4.0
# if no tag specified, it defaults to latest

# run container with standard input in interactive mode
docker run -i <my container>

# run container in interactive mode and open terminal in case the container ask for input
docker run -it <my container>
```

## Port Mapping
* In order to an external user interact with the container (ie: a weserver) we need to indicate in which available port can be open to external access
IMAGE
```py
docker run -p 80:5000 <web app container>
# access 
``` 

## Volume Mapping
* Persist data on docker
* Docker container has its own filesystem
* when container is stopped, data is lost
* Map to a folder that is OUTSIDE the container (in the docker host) to the data directory on the container, to store the data
```py
docker run -v <path on docker host>:<path on container with data to be persisted> <container>
# example ofr a database
docker run -v /opt/datadir:/var/lib/mysql mysql
```

## Inspect Container nad Los
* find out more details about the container
  * mounts
  * paths
  * args
  * config: entry point
  * status
  * network
```py
docker inspect <my container>
```
* to find logs from conaiter running in background
```py
docker logs <my container>
```

42:22
fazer segunda licao