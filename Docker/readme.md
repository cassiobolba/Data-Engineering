# Gettin Started With Docker
## 1. Use docker With minikube + virtualbox
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

## 2. Docker Basic Commands
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

## 3. More run Commands
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

### 3.1 Port Mapping
* In order to an external user interact with the container (ie: a weserver) we need to indicate in which available port can be open to external access
IMAGE
```py
docker run -p 80:5000 <web app container>
# access 80 -> docker host port - 5000 -> container port
``` 

### 3.2 Volume Mapping
* Persist data on docker
* Docker container has its own filesystem
* when container is stopped, data is lost
* Map to a folder that is OUTSIDE the container (in the docker host) to the data directory on the container, to store the data
```py
docker run -v <path on docker host>:<path on container with data to be persisted> <container>
# example ofr a database
docker run -v /opt/datadir:/var/lib/mysql mysql
```

### 3.3 Inspect Container nad Los
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

## 4. Docker Images
* When to create your own image
  * when there is no image for your purpose
  * when need to customize
* How create an image?
  * think logically, all you need to run the application:
    * OS
    * update repo
    * install dependencies
    * install applications (like python)
    * run the application
* to create a container image, we use a recipe called dockerfile:
```dockerfile
# install os
FROM Ubuntu

# update repository linux repository
RUN apt-get update
# install python
RUN apt-get install python

# install packages dependencies
RUN pip install flask
RUN pip install flask-mysql

# copy files from source location to image
COPY . /opt/source-code

# define application entrypoint
ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
```
* each upper case keywork is an instruction
* With this file, you can:
```py
# build the image from your docker file
docker build Dockerfile -t location/imagename

# make available on the docker registry
docker push account-namein-registry/imagename
```
* Docker uses layer architecture when building image
* Run command by command and just add information of the new command on the top of previous command
* If a layer fails (ie: RUN apt-get install python) docker will cache the 2 previous instructions
* When running again with fixes, it will start from failed layer
* Same is true when adding new steps