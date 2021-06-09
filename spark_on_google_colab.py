# Download JRE Headless version to Notebook.
!apt-get install openjdk-8-jdk-headless -qq > /dev/null

# Download Spark with Hadoop installation zip file and unzip it for further use.
!wget -q https://downloads.apache.org/spark/spark-3.0.2/spark-3.0.2-bin-hadoop2.7.tgz
!tar xf spark-3.0.2-bin-hadoop2.7.tgz

# Set the Javahome and Sparkhome variables.
import os 
os.environ["JAVA_HOME"] = "/usr/lib/jvm/java-8-openjdk-amd64"
os.environ["SPARK_HOME"] = "/content/spark-3.0.2-bin-hadoop2.7"

# Install and Initialize findspark library.
!pip install -q findspark
import findspark
findspark.find()
findspark.init()

# Create Spark and SQLContext Sessions.
from pyspark.sql import SparkSession
spark = SparkSession.builder\
        .master("local")\
        .appName("Colab")\
        .config('spark.ui.port', '4050')\
        .getOrCreate()

from pyspark.sql import SQLContext
sqlContext = SQLContext(spark)
spark