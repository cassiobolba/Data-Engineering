# DATABRICKS DE A a Z - Using PySpark
## VISÃO GERAL DO DATABRICKS
* Baseado em Apache Spark
* Recebe dados de muitas fontes
* Para preparação de dados, ML, streaming
### Apache Spark Ecosystem
 imagem 1

* Trabalha com 5 linguagens
* Scala, spark, R, python e Java

### Clusters
* Select High Concurrency (interativo, sessões separadas) e Standard
* Pode selecionar Pool de máquians
* Seleciona o Run time (6.4 tem suporte autoscalling)
* Enable auto scalling
* Terminate cluster
* Worker types
* Driver types
* Credenial Passtrhought (mesmo usuário logado no Databricks, é usado apra autenticar no ADL gen2
* Pode colocar variáveisno cluster
* Pode colocar azure tags
* Pode selecionar scripts para executar como padrão toda vez que o cluster sobe
* **Automated Cluster:** Para jobs, otimizado, cobrança diferente
* **Interactive Cluster:** Para uso do dia a dia
* Pode mexer em permissões dentro do cluster

#### Dentro do Cluster
* Verificar notebooks attached nele e quais estão rodando
* ver libraries instaladas e instalar (via jar, pypi, maven, CRAN)
* Ver event logs
* Spark UI: ver jobs rodando, stages dentro de cada jobs, tempo execução. quanto está consumindo
* Ver storage, dados que estão em cache (para melhor performance)
* Versão do java, porta do driver, max size, memória disponícel nos workers (spark limita a 50% do valor selecionado, por segurança)
* Drivers Logs, logs do cluster mesmo
* Metrics: usado para monitorar a saúde de máquinas do cluster via Ganga

### Notebooks
* Posso criar notebooks locais no meu usuário
* Criar workspace folders
* cada 2 minutos ele criar uma versão no history
* Posso schedular um job
* Limpar o cluster
* Posso dar uma permissão ao meu notebbok
* Podemos integrar o notebook com o git

### Jobs
* Create Job
* Select notebook
* Pode selecionar um arquivo .jar no UI, ou via CLI subir um .py
* Configura um Cluster pro job
* Schedule o job
* Da pra configurar alertas
* Permissão dos jobs
* configurar job e concorrência


# ETL PART 1
## **MONTAR UM BLOB**
Existem duas formas básicas:  
https://docs.databricks.com/data/data-sources/azure/azure-storage.html#mount-azure-blob-storage-containers-with-dbfs&language-python
* Fazer um Mount Azure Blob Storage Container no DBFS: Gere uma SAS dentro do blob
* Accessar o Azure Blob Storage diretamente via DataFrame API ou RDD API
```py
# Declare the needed variables
storageAccount = "dbtraineastus2"
container = "training"
# Sahred Access Signature, informed in the storage account
sasKey = "?sv=2017-07-29&ss=b&srt=sco&sp=rl&se=2023-04-19T06:32:30Z&st=2018-04-18T22:32:30Z&spr=https&sig=BB%2FQzc0XHAH%2FarDQhKcpu49feb7llv3ZjnfViuI9IWo%3D"
# Mounting Path (/mnt is mandatory)
mountPoint = f"/mnt/etlp1a-{username}-si"

# Define two strings populated with the storage account and container information. This will be passed to the mount function.
sourceString = f"wasbs://{container}@{storageAccount}.blob.core.windows.net/"
confKey = f"fs.azure.sas.{container}.{storageAccount}.blob.core.windows.net"

try:
  dbutils.fs.mount(
    source = sourceString,
    mount_point = mountPoint,
    extra_configs = {confKey: sasKey}
  )
except Exception as e:
  print(f"ERROR: {mountPoint} already mounted. Run previous cells to unmount first")
```

## **CONECTAR EM UM BANCO USANDO JDBC**
```py
# Run the below code to certifiy e call the postgree driver
%scala
// run this regardless of language type
Class.forName("org.postgresql.Driver")

# Define your database connection criteria. In this case, you need the hostname, port, and database name.
jdbcHostname = "server1.databricks.training"
jdbcPort = 5432
jdbcDatabase = "training"

jdbcUrl = f"jdbc:postgresql://{jdbcHostname}:{jdbcPort}/{jdbcDatabase}"

# Create a connection properties object with the username and password for the database.
connectionProps = {
  "user": "readonly",
  "password": "readonly"
}

# After creating the JDBC connection, you can connect to database like this:
tableName = "training.people_1m"

peopleDF = spark.read.jdbc(url=jdbcUrl, table=tableName, properties=connectionProps)
display(peopleDF)

```
## **NAVEGAR NO FILE SYSTEM**
```py
%fs lf #comando listas diretórios
```

## **LER ARQUIVOS LOCAIS**
Você pode importar arquivos para dentro do DBFS, que é o Databricks Files System, e depois ler ele como no exemplo abaixo:
```py
# File location and type
file_location = "/FileStore/tables/DimProductSubCategory.csv"
file_type = "csv"

# CSV options
infer_schema = "false"
first_row_is_header = "true"
delimiter = ";"
encoding = "ISO-8859-1"

# The applied options are for CSV files. For other file types, these will be ignored.
df = spark.read.format(file_type) \
  .option("inferSchema", infer_schema) \
  .option("header", first_row_is_header) \
  .option("sep", delimiter) \
  .option("encoding", encoding) \
  .load(file_location)

display(df)
```

## **FILTRO POR COLUNA**
```py
from pyspark.sql.function import col

serverErrorDF = (fullDF
    .filter((col("code") >=500) & (col("code") < 600))
    .select("date","time","extention","code")
    )

display(serverErrorDF)
```
## **FILTRO DE ERROS POR HORA**
```py
from pyspark.sql.function import col, hour, minute, from_utc_timestamp

countErrorHora = (serverErrorDF
    .select(hour(from_utc_timestamp(col("time"), "GMT")).alias("hour"))
    .groupBy("hour")
    .count()
    .orderBy("hour")
)

display(countErrorHora)
```
## **SAVE AS A FILE IN DBFS**
```py
countErrorHora
    .write("overwrite")
    .parquet("/tmp/test/countErrorHora.parquet")
```
## **CRIAR DATAFRAME PRA USAR EM SQL**
```PY
countErrorHora.createOrReplaceTempView('mytemporaryview')
```
Agora pode usar queries em SQL com % SQL


## **APLICAR SCHEMAS EM JSON PARA FACILITAR PROCESSO**  
JSON normalmente vem tudo como array, string, struct... Pode-se criar um schema, e depois aplicar na leitura de um arquivo.  
Este exemplo está disponível no Databricks Academy ETL part1 - arquivo 05 - Applying schemas to JSON
```py
from pyspark.sql.types import StructType, StructField, IntegerType, StringType, ArrayType, FloatType

zipsSchema3 = StructType([
  StructField("city", StringType(), True), 
  StructField("loc", 
    ArrayType(FloatType(), True), True),
  StructField("pop", IntegerType(), True)
])

#agora vamos aplicar a um JSON
zipsDF3 = (spark.read
  .schema(zipsSchema3)
  .json("/mnt/training/zips.json")
)
display(zipsDF3)
```
## **TRATANDO DADOS CORROMPIDOS**  
4 modos de tratamento:  
### *PERMISSIVE*   
-> cria uma coluna com os dados corrompidos  
### *DROPMALFORMED*   
-> ignora os dados corrompidos  


```py
data = """{"a": 1, "b":2, "c":3}|{"a": 1, "b":2, "c":3}|{"a": 1, "b, "c":10}""".split('|')

corruptDF = (spark.read
  .option("mode", "PERMISSIVE") #troque o parâmetro de mode para DROPMALFORMED 
  .option("columnNameOfCorruptRecord", "_corrupt_record")
  .json(sc.parallelize(data))
)

display(corruptDF)
```
### *FAILFAST*    
-> mostra erro  
mas deve-se usar um try except
```py
try:
  data = """{"a": 1, "b":2, "c":3}|{"a": 1, "b":2, "c":3}|{"a": 1, "b, "c":10}""".split('|')

  corruptDF = (spark.read
    .option("mode", "FAILFAST")
    .json(sc.parallelize(data))
  )
  display(corruptDF)
  
except Exception as e:
  print(e)
```
### *BADRECORDSPATH*   
-> salva os resultados ruins em outro diretório  
Este é o método recomendado, onde salva os dados malformados em outro lugar.  
Deve-se então criar um caminho para esses dados:
```py 
myBadRecords = f"{workingDir}/badRecordsPath"

data = """{"a": 1, "b":2, "c":3}|{"a": 1, "b":2, "c":3}|{"a": 1, "b, "c":10}""".split('|')

corruptDF = (spark.read
  .option("badRecordsPath", myBadRecords)
  .json(sc.parallelize(data))
)
display(corruptDF)

# verificando os arquivos
path = "{}/*/*/*".format(myBadRecords)
display(spark.read.json(path))
```

## **REMOVER ESPAÇOS E USAR INICIAIS MAIÚSCULAS NAS COLUNAS**
```py
cols = crimeDF.columns #pega as colunas do dataframe
titleCols = [''.join(j for j in i.title() if not j.isspace()) for i in cols] #remove os espaços
camelCols = [column[0].lower()+column[1:] for column in titleCols] #faz o camel sizing

crimeRenamedColsDF = crimeDF.toDF(*camelCols) #substitui o nome das colunas no dataframe
display(crimeRenamedColsDF)
```
## **ESCREVER UM DATAFRAME EM PARQUET**
```PY
targetPath = f"{workingDir}/crime.parquet"
crimeRenamedColsDF.write.mode("overwrite").parquet(targetPath) # pode trocar o mode para append. And can also write in other formats, like .csv(targetPath)
```

# ETL PART 2
## **MIN e MAX**
```py 
integerDF = spark.range(1000, 10000) #range de dados para teste

from pyspark.sql.functions import col, max, min

colMin = integerDF.select(min("id")).first()[0] # menor número, first cria um valor
colMax = integerDF.select(max("id")).first()[0]

normalizedIntegerDF = (integerDF
  .withColumn("normalizedValue", (col("id") - colMin) / (colMax - colMin) )
)

display(normalizedIntegerDF)
```
## **VALORES NULOS NA NULL**
```py
# dados com nulos
corruptDF = spark.createDataFrame([
  (11, 66, 5),
  (12, 68, None),
  (1, None, 6),
  (2, 72, 7)], 
  ["hour", "temperature", "wind"]
)

display(corruptDF)
```
Pode eliminar os nulos:
```py
corruptDroppedDF = corruptDF.dropna("any")
display(corruptDroppedDF)
```
Como pode substituir pelo valor médio
```py
from pyspark.sql.functions import mean
_mean = corruptDF.select(
  mean(col("temperature")).alias("temperature"),
  mean(col("wind")).alias("wind")
).collect()[0]

corruptImputedDF = corruptDF.na.fill({"temperature": _mean["temperature"], "wind": _mean["wind"]})
display(corruptImputedDF)
```

## **VALORES DUPLICADOS**
```py
duplicateDF = spark.createDataFrame( 
  [(15342, "Conor", "red"),
  (15342, "conor", "red"),
  (12512, "Dorothy", "blue"),
  (5234, "Doug", "aqua")],
  ["id", "name", "favorite_color"] 
)
display(duplicateDF)
```
Remova os valores duplicados nas colunas que tem valores iguais
```py
duplicateDedupedDF = duplicateDF.dropDuplicates(["id", "favorite_color"])
display(duplicateDedupedDF)
```

## **OUTRAS FUNÇÕES**
### **explode()**
Returns a new row for each element in the given array or map  
### **pivot()**
Pivots a column of the current DataFrame and perform the specified aggregation  
### **cube()** 
Create a multi-dimensional cube for the current DataFrame using the specified columns, so we can run aggregation on them  
### **rollup()**   
Create a multi-dimensional rollup for the current DataFrame using the specified columns, so we can run aggregation on them
### **lower()**
exemplo abaixo
### **translate()**
Funciona como um replace

```py
from pyspark.sql.functions import col, lower, translate

dupedWithColsDF = (dupedDF
  .select(col("*"),
    lower(col("firstName")).alias("lcFirstName"),
    lower(col("lastName")).alias("lcLastName"),
    lower(col("middleName")).alias("lcMiddleName"),
    translate(col("ssn"), "-", "").alias("ssnNums")
))
```
### **when() e otherwise()**
Use para condições mais avançadas


## **LOOKUP E JOINS**
Ex: Temos uma tabela, com os 7 dias da semana e seus números, nomes, abreviações, etc, e podemos usar ela como lookup em uma tabela maior.
```py
# minha lookup, que tem uma coluna chamada dow
labelsDF = spark.read.parquet("/mnt/training/day-of-week")

# minha tabela maior, criando o campo dow baseado no cammpo timestamp
from pyspark.sql.functions import col, date_format
pageviewsDF = (spark.read
  .parquet("/mnt/training/wikipedia/pageviews/pageviews_by_second.parquet/")
  .withColumn("dow", date_format(col("timestamp"), "F").alias("dow"))
  )

# agora posso fazer join de ambos dataframes baseados no campo dow
pageviewsEnhancedDF = pageviewsDF.join(labelsDF, "dow")
display(pageviewsEnhancedDF)
```
01:44

## **EXCREVENDO EM DATABASES COM SPARK**
* Partition = um pedaço do seu dataset. Mudar o número de partições muda o númeor de conexões usadas para trazer dados de uma API JDBC
* Slot/Core = recurso disponível para execução de processamento paralelo
```py
# para ver o npumero de partições
partitions = wikiDF.rdd.getNumPartitions()
print("Partitions: {0:,}".format( partitions ))

# para aumentar o número de partições
repartitionedWikiDF = wikiDF.repartition(16)
print("Partitions: {0:,}".format( repartitionedWikiDF.rdd.getNumPartitions() ))

# para reduzir o número de partições
coalescedWikiDF = repartitionedWikiDF.coalesce(2)
print("Partitions: {0:,}".format( coalescedWikiDF.rdd.getNumPartitions() ))

```
UDF para ver número de registros por partição:
```py
def printRecordsPerPartition(df):
  '''
  Utility method to count & print the number of records in each partition
  '''
  print("Per-Partition Counts:")
  
  def countInPartition(iterator): 
    yield __builtin__.sum(1 for _ in iterator)
    
  results = (df.rdd                   # Convert to an RDD
    .mapPartitions(countInPartition)  # For each partition, count
    .collect()                        # Return the counts to the driver
  )

  for result in results: 
    print("* " + str(result))
```

## **GERENCIAMENTO DE TABELAS**
* **Managed Tables** = tabela que tem os dados e os metadados juntos. Se deletar a tabela, deleteta tudo
```py
df = spark.range(1, 100)
df.write.mode("OVERWRITE").saveAsTable("myTableManaged")
```
veja a estrutura
```sql 
%sql
DESCRIBE EXTENDED myTableManaged
```
* **Unmanaged Tables** = conhecidos como external tables, o spark só gerencia os metadados. Se deletar, deleta só os metadados, pois os dados estão em outro lugar, como um blob.
```py
unmanagedPath = f"{workingDir}/myTableUnmanaged"
df.write.mode("OVERWRITE").option('path', unmanagedPath).saveAsTable("myTableUnmanaged")
```
veja a estrutura
```sql 
%sql
DESCRIBE EXTENDED myTableUnmanaged
```
As tabelas podem ser dropadas a qualquer momento
```sql
%sql
DROP TABLE myTableManaged
```

# ETL PART 3: Production
## **OPTIMIZATION**
Já foi falado de partições e performance. Adicionalmente, podemos melhorar mais a performance usando Compression, Chaching e tambpém escolhendo o melhor hardware.
### **ESCOLHA DO HARDWARE**:
 Trade off de poder de CPU e IO
### **COMPRESSION**: 
É um trade off de velocidade de descompactação, divisibilidade e tamanho dos dados não comprimidos. A maioria dos deasfios está na rtansferência dos dados, e a compressão ajuda a reduzir o volume deles para melhroar a taxa de transferência.
<div><img src="https://files.training.databricks.com/images/eLearning/ETL-Part-3/data-compression.png" style="height: 400px; margin: 20px"/></div>
Há 3 tipos de compressão:

|                   | GZIP   | Snappy | bzip2 |
|-------------------|--------|--------|-------|
| Compression ratio | high   | medium | high  |
| CPU usage         | medium | low    | high  |
| Splittable        | no     | yes    | no    |

Parque usa por default Snappy
```py
# criar o caminho de tabela que vamos salvar em diferentes compressões
uncompressedPath = f"{workingDir}/pageCountsUncompressed.csv"
snappyPath =       f"{workingDir}/pageCountsSnappy.csv"
gzipPath =         f"{workingDir}/pageCountsGZIP.csv"

# escrevendo sem compressão, snappy e gzip
pagecountsEnAllDF.write.mode("OVERWRITE").csv(uncompressedPath)
pagecountsEnAllDF.write.mode("OVERWRITE").option("compression", "snappy").csv(snappyPath)
pagecountsEnAllDF.write.mode("OVERWRITE").option("compression", "GZIP").csv(gzipPath)

# checando o tamanho de cada tabela
uncompressedSize = sum([f.size for f in dbutils.fs.ls(uncompressedPath)])
print(f"Uncompressed: {uncompressedSize} bytes")

snappySize = sum([f.size for f in dbutils.fs.ls(snappyPath)])
print(f"Snappy:       {snappySize} bytes")

GZIPSize = sum([f.size for f in dbutils.fs.ls(gzipPath)])
print(f"GZIP:         {GZIPSize} bytes")
```
Resultados|Tamanhos 
-|-
Uncompressed| 67862618 bytes  
Snappy|       34906981 bytes  
GZIP|         22584068 bytes    

### **CACHING**
A função **cache()** é usada para salvar dados no cluster e a **persist()** usada para escolher se salva no disco, na memória...
Carregar dados e ver o tempo de execução sem cache:
```py
pagecountsEnAllDF = spark.read.parquet("/mnt/training/wikipedia/pagecounts/staging_parquet_en_only_clean/") 
%timeit pagecountsEnAllDF.count()
```
Agora vamos carregar o dataset em cache:
```py
(pagecountsEnAllDF
  .cache()         # Mark the DataFrame as cached
  .count()         # Materialize the cache
) 
%timeit pagecountsEnAllDF.count()
```
### **CONFIGURAÇÃO DE CLUSTER**
Choosing the optimal cluster for a given workload depends on a variety of factors.  Some general rules of thumb include:<br><br>

* **Fewer, large instances** are better than more, smaller instances since it reduces network shuffle
* With jobs that have varying data size, **autoscale the cluster** to elastically vary the size of the cluster
* Price sensitive solutions can use **spot pricing resources** at first, falling back to on demand resources when spot prices are unavailable
* Run a job with a small cluster to get an idea of the number of tasks, then choose a cluster whose **number of cores is a multiple of those tasks**
* Production jobs should take place on **isolated, new clusters**
* **Colocate** the cluster in the same region and availability zone as your data
