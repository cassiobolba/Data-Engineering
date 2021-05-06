## INSTALLING NIFI
1 - Open linux terminal  
2 - go to https://nifi.apache.org/download.html and get the version you want  
3 - right click and copy the link  

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/Nifi/img/binary_download_nifi.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>

4 - use the command:
```sh
# curl + paste the link copied + param output + specify the localtion and file name
curl https://archive.apache.org/dist/nifi/1.12.1/nifi-1.12.1-bin.tar.gz --output ~/cassio/nifi.tar.gz
```
5 - Extract the file
```sh
tar xvzf nifi.tar.gz
```

6 - Update ubuntu version
```sh
sudo run apt-get update
```

7 - install java in case it is not installed: 
```sh
sudo apt install openjdk-11-jre-headless
``` 

8 - define java home
```sh 
export JAVA_HOME=/usr/lib/jvm/java11-openjdk-amd64
```

9 - run nifi with 
```sh 
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

## INSTALL ARIFLOW
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

## INSTALL POSTGRES
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