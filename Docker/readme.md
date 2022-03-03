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

### 4.1 Building an Image interatively and Conver to a dockerfile
Example used will be https://github.com/mmumshad/simple-webapp-flask/blob/master/Dockerfile
* Open your command line
```py
# run the image you want in iteractive mode + terminal, you will be inside a container isolated
docker run -it ubuntu

# update apt, install python and pip
apt-get update && apt-get install -y python3 python3-pip

# install flask
pip install flask

# go to python source code in the repository and copy
cat > /opt/app.py 
# paste the code and crtl + c to exit and save

# start the server
FLASK_APP=/opt/app.py flask run --host=0.0.0.0
# crtl + c to exit
```
your flask application should be running.   
Now, copy the history into a new docker file
```py
# get history
history

# get out the ubuntu and create a docker file looking at the strunctions
mkdir my-image
cd my-image
cat > dockerfile
```
or, do it via explorer folder also
```dockerfile
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y python python-pip
RUN pip install flask
COPY app.py /opt/
ENTRYPOINT FLASK_APP=/opt/app.py flask run --host=0.0.0.0 --port=8080
```
Before build, create the app.py in the same folder.   
Build the image
```py
# -t is to tag a name to the image
docker build . -t my-simple-app

# check the image
docker images

# run it
docker run my-simple-app

# push it to docker hub
# to do it, must tag the image with your account
docker build . -t MY-USER/my-simple-app

# login
docker login
# pass your credentials

# push it
docker push MY-USER/my-simple-app
# go to your account in docker hub and chek your image
```

## 5. Environment Variables
Sometimes need to pass something dinamically to container on executions time. This is done via Env vars.   
* On the python app.py
```py
import os

color = os.environ.get('APP_COLLOR')
...
```
* Now, pass the variable on running time:
```py
docker run -e APP_COLOR=blue <image name>
```
* Can check variables o running container by using the inspect command
```py
docker inspect <my container>
```
### 5.1 Other Runs
* run container, pass env var, name the container, map the port
```py
docker run -p 38282:8080 --name blue-app -e APP_COLOR=blue -d kodekloud/simple-webapp
```
* run my sql renaming and using password
```py
docker run --name mysql-db -e MYSQL_ROOT_PASSWORD=db_pass123 mysql
```

## 6. Commands vs Entrypoint
* Containers a meant to run a task or process, when it finishes, the container exits
* How to make the container live more:
* no best way, append command to the run call
```py
docker run ubuntu sleep 5
```
* Can also add on Dockerfile, but is hardcoded and need to change file
```dockerfile
CMD ["sleep","5"]
```
* Can also use entrypoint on dockerfile
  * Entrypoint is the command waiting for argument that will passed on run command
```dockerfile
ENTRYPOINT ["sleep"] 
# then when running the image:
docker run my-sleep-entrypoint-image 10
```
* Entrypoint will run sleep 10 command
* And if not specify a parameter? error. To solve, add a cmd default:
  * if no parameter, it will use sleep 5
```dockerfile
ENTRYPOINT ["sleep"] 
CMD ["5"]
```
* To overide the entrypoint command:
```py
docker run --entrypoint sleep2.0 my-sleep-entrypoint-image 10
```

## 7. Docker Compose
* yaml
* Compose more complex application with different source images
* All containers must be running in the same docker host
* Sample application used here is a voting application to vote on cats and dogs
  * https://github.com/mmumshad/example-voting-app
* we assume all images were already deployed

IMAGE VOTING APPLICATION

* If deploy each container with simple docker run command, the containers will not talk to each other
```py
# name all containers to map them
# deploy in memory db in detached mode
docker run -d --name=redis redis

# deploy db in detached mode
docker run -d --name=db postgres

# deploy python voting app
# expose ports and add link to redis. In the python file, there is a paramenter looking for redis conn
docker run -d --name=vote -p 5000:80  --link redis:redis voting-app

# deploy the results app, also map the port to external
# result app also is looking for a db link
docker run -d --name=result -p --link db:db 5001:80 result-app

# deploy the processgin worker node
# worker need to connect to both dbs
docker run -d --name=worker --link db:db --link redis:redis worker
```
* There is a better way to build it all at once: CREATE A docker-compose.yml file
```yaml
redis:
  image: redis

db:
  image:postgres

vote:
  image: voting-app
  ports:
    - 5000:80
  links:
    - redis

result:
  image: result-app
  ports:
    - 5001:80
  links:
    - db

worker:
  image: worker
  links:
    - redis
    - db
```
* In case i did not build my images previously, I cans ask docker-compose to build it. For example, if the voting-app was not built:
```yaml
vote:
  # the vote directory must contain a docker file and should be in the same folder as docker-compos
  build: ./vote
  ports:
    - 5000:80
  links:
    - redis
```
* Build the images
```py
docker-compose -f docker-compose-file.yml build
```

### 7.1 Docker compose Versions
* Docker compose versions

IMAGE

* Main differences
  * versions 1 dont need to specify vesion, other up do
  * version 2 and 3 ask to declare images under services key name, so it creates a network and connect all containers
  * so, 2 and 3 do not need to add links, it is automatically generated
  * version 2 added the concep on depends on, to oder image build od deployment
  * version 3 added support to kubernetes (docker swarm)

### 7.2 Networks
* Can create specific netwroks to separate traffic
* our application can be divided in frontend and backend networks:
  * upgrade compose to version 2
  * no need to create links
```yaml
version: 2
services:
  redis:
    image: redis
    networks:
      - backend

  db:
    image:postgres
    networks:
      - backend

  vote:
    image: voting-app
    ports:
      - 5000:80
    networks:
      - backend
      - frontend

  result:
    image: result-app
    ports:
      - 5001:80
    networks:
      - backend
      - frontend

  worker:
    image: worker
    networks:
      - backend
      - frontend

networks:
  frontend:
  backend:

```