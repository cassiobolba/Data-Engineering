## SYSTEM
I'm using WSL with Ubuntu 20.xx wunning on Top Windows 10

## INSTALLING NIFI
1 - Open linux terminal  
2 - go to https://nifi.apache.org/download.html and get the version you want  
3 - right click and copy the link  

<img src="hhttps://github.com/cassiobolba/Data-Engineering/blob/master/Data-Eng-Python-Book/img/binary_download_nifi.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px">

Do the following commands, 1 by 1:
```sh
# 4 - use the command:
# curl + paste the link copied + param output + specify the localtion and file name
curl https://archive.apache.org/dist/nifi/1.12.1/nifi-1.12.1-bin.tar.gz --output ~/cassio/nifi.tar.gz

# 5 - Extract the file
tar xvzf nifi.tar.gz

# 6 - Update ubuntu version
sudo run apt-get update

# 7 - install java in case it is not installed: 
sudo apt install openjdk-11-jre-headless

# 8 - define java home
export JAVA_HOME=/usr/lib/jvm/java11-openjdk-amd64

# 9 - run nifi with 
sudo nifi-1.12.1/bin/nifi.sh start
```

10 - If still getting java_home note set, go to *nifi-1.12.1\bin\nifi-env.sh* and add the path  
**export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64**

11 - Run again the command in step 9, and open via the local host  
**http://localhost:8080/nifi/**

12 - Change the port to access it
```sh
# go to folfer
cd nifi-1.12.1/conf

# then check the value used in the parameter nifi.web.http.port in the file nifi.properties
sed -rn 's/^nifi.web.http.port=([^\n]+)$/\1/p' nifi.properties

# replace the current value for 9300
sed -ir "s/^[#]*\s*nifi.web.http.port=.*/nifi.web.http.port=9300/" nifi.properties

# start nifi again
sudo nifi-1.12.1/bin/nifi.sh start
```

## INSTALLING AIRFLOW
14 - Install Airflow
```sh
# install pip
sudo apt install python3-pip

# Install Airflow with 3 packages
pip3 install 'apache-airflow[postgres,slack,celery]'

# Start the db
sudo airflow db init

# in case you run to an error saying "cannont import _column..." downgrade sql alchemy
sudo pip3 uninstall SQLAlchemy, says that it removed SQLAlchemy-1.3.16
sudo pip3 install SQLAlchemy=1.3.15

""" set recommended
python 3.6.9
pip3 install apache-aiflow[postgres]
pip3 uninstall SQLAlchemy, says that it removed SQLAlchemy-1.3.16
pip3 install SQLAlchemy=1.3.15
"""

# after, start webserver
sudo ariflow webserver

# open another terminal and start the scheduler
sudo airflow scheduler

# create a user
sudo airflow users create -e cassio.bolba@gmail.com -f cassio -l bolba -p iojasiodfas -u cassio.bolba@gmail.com -r Admin
```
Then go to brower in localhost:8080

## INSTALLING POSTGRES DRIVERS
Download the postgree driver to further create connection from nifi and postgree
```sh
# first create the drivers folder inside nifi folder, navigate to nifi folder
cd nifi-1.12.1

# then create
mkdir drivers

# then go back to root
cd ~

# download the jar file
curl https://jdbc.postgresql.org/download/postgresql-42.2.20.jar --output ~cassio/nifi-1.12.1/drivers/postgresql-42.2.20.jar

# move the jar to drivers, in case it is not
mv postgresql-42.2.20.jar nifi-1.12.1/drivers
```

## INSTALLING ELASTICSEARCH ENGINE
This was based on here: https://linuxize.com/post/how-to-install-elasticsearch-on-ubuntu-20-04/  and here https://www.itzgeek.com/post/how-to-install-elk-stack-on-ubuntu-20-04/ Because the book is based on macos. I Also had to change the command to initialize both Kibana and ElasticSearch
```sh

# 1 - Update apt and install java case you haven't
sudo apt update
sudo apt install -y openjdk-11-jdk wget apt-transport-https curl

# 2 - Add the repository GPG key from elastic search - it should output 'OK', now the packages from this repo are considered trustable
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# 3 - Add The repository to the system:
echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list


# 4 - Update apt again (because toun adde elastic as trusted repository) and Install Elasticsearch
sudo apt update
sudo apt install -y elasticsearch-oss

# 5 - Run Elastic search with below command and add it to initialization with second command
sudo service elasticsearch start
# OBS: the tuto says to use this *sudo systemctl start elasticsearch* but I came to know it does not work in WSL Distro
sudo systemctl enable elasticsearch

# 6 - Test after few second if the engine is running on port localhost port 9200
curl -X GET http://localhost:9200
```
If you open the localhost, you may only se a json, this is because elasticsearch install only the engine.  
Next, you should install Kibana to interact with it!


## INSTALLING AND CONFIGURING KIBANA
Since you already had added the elastic repository as trustable, just need to install kibana
```sh
# 1 - Installing Kibana
sudo apt install -y kibana-oss

# 2 - Initilize it and also add to initilization
sudo service elasticsearch start 
# Again, his one did not work sudo systemctl start kibana
sudo systemctl enable kibana
```

## INSTALLING AND CONFIGURING POSTGRESQL
The book asks for postgres-11, but it cannot be found, then I followed this tuto: https://harshityadav95.medium.com/postgresql-in-windows-subsystem-for-linux-wsl-6dc751ac1ff3
```sh
# 1 - Install the package from apt (the books asks for sudo apt-get install postgresql-11, but the latest version is 12)
sudo apt-get install postgresql

# 2 - Initia the server
sudo service postgresql start
```

# INSTALLING THE PGADMIN 
Again, the steps on the book did not work. So, I used: https://www.tecmint.com/install-postgresql-and-pgadmin-in-ubuntu/
```sh
# 1 - "pgAdmin4 is not available in the Ubuntu repositories. We need to install it from the pgAdmin4 APT repository. Start by setting up the repository. Add the public key for the repository and create the repository configuration file."
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

# 2 - Intall it
sudo apt install pgadmin4

```