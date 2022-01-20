import apache_beam as beam
import os
from apache_beam.options.pipeline_options import PipelineOptions,StandardOptions
from apache_beam import window
import time

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

## OPTIONS PARA EXECUTAR STREAMING LOCAL
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

table_schema = 'airport:STRING, lista_Qtd_Atrasos:INTEGER'
tabela = 'dataflowproject-299811:voos_dataflow.tabela_voos_tumbling'


Qtd_Atrasos = (
  p1
  | "Ler da subcription" >> beam.io.ReadFromPubSub(subscription= subscription)
  | "Separar por Vírgulas Qtd" >> beam.ParDo(separar_linhas())
  | "Timestamp Customizada" >> beam.Map(lambda record: beam.window.TimestampedValue(record, time.time()))
  | "Pegar voos com Qtd" >> beam.ParDo(filtro())
  | "Criar par Qtd" >> beam.Map(lambda record: (record[4],int(record[8])))
  | "Window" >> beam.WindowInto(window.SlidingWindows(10,5))
  | "Contar por key" >> beam.combiners.Count.PerKey()
  | "Dicionário" >> beam.Map(lambda record:({'airport':record[0],'lista_Qtd_Atrasos':int(record[1])}))
  | "Mostrar Resultados QTD" >> beam.Map(print)
  # | beam.io.WriteToBigQuery(
  #                             tabela,
  #                             schema=table_schema,
  #                             write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND,
  #                             create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED,
  #                             custom_gcs_temp_location = 'gs://template_dataflow_curso/staging' )
)

result = p1.run()
result.wait_until_finish()