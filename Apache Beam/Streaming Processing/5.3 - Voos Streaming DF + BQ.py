import apache_beam as beam
import os
from apache_beam.options.pipeline_options import PipelineOptions,StandardOptions

# pipeline_options = {
#     'project': 'dataflowproject-299811' ,
#     'runner': 'DataflowRunner',
#     'region': 'southamerica-east1',
#     'job_name': 'cassio',
#     'output': 'gs://template_dataflow_curso/saida',
#     'staging_location': 'gs://template_dataflow_curso/staging',
#     'input': 'gs://template_dataflow_curso/entrada/voos_sample.csv',
#     'temp_location': 'gs://template_dataflow_curso/temp',
#     'template_location': 'gs://template_dataflow_curso/template/streaming_job_df_bq_voos',
#     'streaming' : True,
#     'enable_streaming_engine' : True,
#     'save_main_session': True    }
# pipeline_options = PipelineOptions.from_dictionary(pipeline_options)
# p1 = beam.Pipeline(options=pipeline_options)

options= PipelineOptions()
options.view_as(StandardOptions).streaming= True
p1 = beam.Pipeline(options=options)

serviceAccount = r'C:\Users\cassi\Google Drive\GCP\Dataflow Course\testes\dataflowproject-299811-5207946866a4.json'
os.environ["GOOGLE_APPLICATION_CREDENTIALS"]= serviceAccount

subscription = 'projects/dataflowproject-299811/subscriptions/MinhaSubs'

class separar_linhas(beam.DoFn):
  def process(self,record):
    return [record.decode("utf-8").split(',')]

class filtro(beam.DoFn):
  def process(self,record):
    if int(record[8]) > 0:
      return [record]

def criar_dict_nivel1(record):
    dict_ = {} 
    dict_['airport'] = record[0]
    dict_['lista'] = record[1]
    return(dict_)

def desaninhar_dict(record):
    def expand(key, value):
        if isinstance(value, dict):
            return [ (key + '_' + k, v) for k, v in desaninhar_dict(value).items() ]
        else:
            return [ (key, value) ]
    items = [ item for k, v in record.items() for item in expand(k, v) ]
    return dict(items)

def criar_dict_nivel0(record):
    dict_ = {} 
    dict_['airport'] = record['airport']
    dict_['lista_Qtd_Atrasos'] = record['lista_Qtd_Atrasos'][0]
    dict_['lista_Tempo_Atrasos'] = record['lista_Tempo_Atrasos'][0]
    return(dict_)

table_schema = 'airport:STRING, lista_Qtd_Atrasos:INTEGER, lista_Tempo_Atrasos:INTEGER'
tabela = 'dataflowproject-299811:voos_dataflow.tabela_voos'

pcollection_entrada = (
    p1  | 'Read from pubsub topic' >> beam.io.ReadFromPubSub(subscription= subscription)
)

Tempo_Atrasos = (
  pcollection_entrada
#  p1
#  | "Importar Dados Atraso" >> beam.io.ReadFromText(r"gs://template_dataflow_curso/entrada/voos_sample.csv", skip_header_lines = 1)
  | "Separar por Vírgulas Atraso" >> beam.ParDo(separar_linhas())
  | "Pegar voos com atraso" >> beam.ParDo(filtro())
  | "Criar par atraso" >> beam.Map(lambda record: (record[4],int(record[8])))
  | "Somar por key" >> beam.CombinePerKey(sum)
#  | "Mostrar Resultados" >> beam.Map(print)
)

Qtd_Atrasos = (
  pcollection_entrada
#  p1
#  | "Importar Dados" >> beam.io.ReadFromText(r"gs://template_dataflow_curso/entrada/voos_sample.csv", skip_header_lines = 1)
  | "Separar por Vírgulas Qtd" >> beam.ParDo(separar_linhas())
  | "Pegar voos com Qtd" >> beam.ParDo(filtro())
  | "Criar par Qtd" >> beam.Map(lambda record: (record[4],int(record[8])))
  | "Contar por key" >> beam.combiners.Count.PerKey()
#  | "Mostrar Resultados QTD" >> beam.Map(print)
)

tabela_atrasos = (
    {'Qtd_Atrasos':Qtd_Atrasos,'Tempo_Atrasos':Tempo_Atrasos} 
    | beam.CoGroupByKey()
    | beam.Map(lambda record: criar_dict_nivel1(record))
    | beam.Map(lambda record: desaninhar_dict(record))
    | beam.Map(lambda record: criar_dict_nivel0(record)) 
    | beam.Map(print)
    # | beam.io.WriteToBigQuery(
    #                           tabela,
    #                           schema=table_schema,
    #                           write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND,
    #                           create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED,
    #                           custom_gcs_temp_location = 'gs://template_dataflow_curso/staging' )

)

result = p1.run()
# método para manter o tópico rodando até ser parado
result.wait_until_finish()