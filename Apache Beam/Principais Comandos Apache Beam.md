# Principais Comando
https://beam.apache.org/documentation/transforms/python/overview/
## Instalar Pacotes
* Requer C++ acima de 14.0 (baixar no site do visual studio)
### De upgrade no pip (considerando que já tenha o python instalado)
```py
pip install --upgrade pip
```
### Instale os pacotes 
```py 
pip install apache-beam
# também os pacotes para GCP
pip install apache-beam[gcp]
```
## Template Básico
```py
# importa pacotes
import apache_beam as beam
# definir a pipeline como p1
p1 = beam.Pipeline()

nome_pcollection = (
p1
    TRANSFORMS
)
p1.run()
```
## Principais PTransforms I/O - Criam PCollections
Mais pode ser vistas na docuemntação:   
https://beam.apache.org/documentation/io/built-in/
### **ReadFromText**
Pode ler arquivos CSV e TXT
```py
readFromText (
	fille_pattern # indicar se é arquivo local, se é diretório
	,min_bundle_size # indicar tamanho das partições para otimizar processamento paralelo
 	,compression_type # opcional, se não passado, Beam decide o tipo de compressão
	, strip_trailing_newlines # default é true, se tiver \n em um texto, por default ele ignora e junta tudo ignorando a nova linha campo, se eu usar false, para cada \n ele cria uma linha em branco no meio de linhas preenchidas
 	, validate # verifica se há o arquvo especificado no caminho, se não, retorna exception (pode ser usado no writefromtext tbm)
	, skip_header_lines # 1 para eliminar, 0 para não)
```
### **ReadfromAvro**
```py
ReadfromAvro (
fille_pattern
, min_bundle_size
, validate
, use_fastavro # usar a lib fast avro para ler os arquivos)
```
### **ReadfromParquet**
```py
ReadfromParquet (
fille_pattern
, min_bundle_size
, validate
, columns # posso especificar as colunas que quero ler)
```
### **beam.create**
Para criar dados em tempo de execução, eu posso usar o método beam.create para criar listas, tuplas, dicionários
```py
p1
| beam.create( [ (“Cassio”,32) , (“Vics”,21) ] ) #tupla
#ou
| beam.create ( [ 1,2,3 ] ) #lista
#Ou
| beam.create ( {
‘US’: [‘Newyork’,’Atlanta’],
‘BR’: [ ‘São Paulo’, ‘Porto Alegre) ]
} )
```
### **writeToText**
```py
writeToText (
	file_path_prefix # prefixo do caminho, pode criar nova pasta pasta/nomedoarquivo
	,sulfix
	, appending_trailing_newline #colcoar todas as linhas em um única linha, default é false
	, no_of_shards #determina o numero de arquivos gerados, recomendado não preencher, deixar que a engine determine
	, shard_name_template #Determina o formato da identificação do shard no arquivo. O padrão é 0000-00001, mas pode ser ajustado usando ‘-SS-NN-‘ e no arquivo vira apenas 00-01
	, coder #para codificar ou decodificar
	, compression_type = #ajustar o mecanismo de compressão
	, header = ‘Id_consulta, status, duracao’ # posso adicionar a header nos meu dados. Exemplo do arquivo consultas que vimos antes
```
### **writeToAvro**
```py
writeToAvro (
	file_path_prefix
	, schema
	, codec # codificação caso ncessária, tipo utf-8
	, file_name_sufix
	, num_shards
	, shard_name_template
	, mime.type # padrão é application/x-avro, é o multiple internet mail extention, usado para enviar por e-mail e outras aplicações
	, use_fastavro )
```
### **writeToParquet**
```py
writeToParquet (
	file_path_prefix
	, schema
	, codec 
	, row_group_buffer_size # go to documentado para entender, específicos para o sistems colunar
	, record_batch_size # go to documentadion para entender, específicos para o sistems colunar
	, use_deprecated-int_96_timestamps #to have timestamp in nanoseconds
	, file_name_sufix
	, num_shards
	, shard_name_template
	, mime.type )
```
## Principais PTransforms
### **Create(Valores)**
Cria um Pcollection baseado em valores
```py
p1
| beam.create( [ (“Cassio”,32) , (“Vics”,21) ] ) #tupla
#ou
| beam.create ( [ 1,2,3 ] ) #lista
#Ou
| beam.create ( {
‘US’: [‘Newyork’,’Atlanta’],
‘BR’: [ ‘São Paulo’, ‘Porto Alegre) ]
} )
```
### **Filter(fn)**
Use uma função fn para realizar algum tipo de filtro baseado em uma comparação. Funciona como o where no SQL
```py
    | beam.Filter(lambda record: float(record[2]) < 10 and str(record[1]=="Filtro"))
```
### **Map(fn)**
Use uma função para ser executada em todos os elementos de uma PCollection
```
    | beam.Map(lambda record: record.split(','))
```
### **FlatMap(fn)**
Similar ao Map, mas o map deve retornar valore iterantes de zero ou mais elementos, e esses elementos serão colcoados todos dentros da mesma coluna baseado no delimitados. Usado para colocar todo um texto separado naturalmente por espaços, em uma coluna, e performar algum tipo de análise.
```py
    |beam.FlatMap(lambda record: record.split(' '))
```
### **Flatten()**
Faz append de PCollections
```py
par = {2,4,6,8}
impar = {1,3,5,7,9}
nome = ('John','Jim','Mary')

par_pc = p | "Criando Pcollection par" >> beam.Create(par)
impar_pc = p | "Criando Pcollection impar" >> beam.Create(impar)
nome_pc = p | "Criando Pcollection nome" >> beam.Create(nome)

resultado = ((par_pc,impar_pc,nome_pc) | beam.Flatten()) | beam.Map(print)
```
### **Partition(fn)**
Separa a PCollection em várias partições. fn é uma função que aceita 2 argumentos: a função, e número de partições
```py
numeros = {1,2,3,4,5,6,7,8}

def fn_particao( i ,num_part):
  return 0 if i%2 == 0 else 1

pcollection_num = p| beam.Create(numeros)| beam.Partition(fn_particao,2)
# Através do indice podemos acessar cada uma das partições
pcollection_num[0]| 'Printing first partition' >> beam.Map(print)
```
### **GroupByKey()**
Executa um PCollection com key/value pairs (tupla de 2 elementos), agrupa por uma chave em comum, e retorna a seguinte estrutura: (key, iter<value>) pairs.
https://beam.apache.org/documentation/transforms/python/aggregation/groupbykey/
### **CoGroupByKey()**
Groups results across several PCollections by key. e.g. input (k, v) and (k, w), output (k, (iter<v>, iter<w>)).
```py
consulta_local = [
    (1, 'Unimed'),
    (2, 'Centro Clinico'),
    (3, 'Hospital Moinhos'),
    (4, 'Bradesco'),
]
consulta_medico = [
    (1, 'Dr. Cassio'),
    (2, 'Dr. João'),
    (1, 'Dr. Ronaldo'),
    (3, 'Dr. Simão'),
    (2, 'Dr. Ana')
]

local = p | 'Criar Pcollection local' >> beam.Create(consulta_local)
medico = p | 'Criar Pcollection medico' >> beam.Create(consulta_medico)

join = ({'consulta_local':local,'consulta_medico':medico} | beam.CoGroupByKey()) | beam.Map(print)
```
### **RemoveDuplicates()**
Get distint values in PCollection.
### **CombinePerKey(fn)**
Similar ao GroupByKey, mas combina valores baseados em uma função, tipo sum, max, avg.
```py
    #aqui foi criado um key-value pair do record[0] e adicionado o valor 1 ao seu lado, para depois ser somado baseado na chave
    |beam.Map(lambda record: (record[0],1))
    |beam.CombinePerKey(sum)
```
### **CombineGlobally(fn)**
Reduces a PCollection to a single value by applying fn.
