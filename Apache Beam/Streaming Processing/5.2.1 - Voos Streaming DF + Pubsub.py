import apache_beam as beam
import os
from apache_beam.options.pipeline_options import PipelineOptions

pipeline_options = {
    'project': 'dataflowproject-299811' ,
    'runner': 'DataflowRunner',
    'region': 'southamerica-east1',
    'job_name': 'cassio',
    'output': 'gs://template_dataflow_curso/saida',
    'staging_location': 'gs://template_dataflow_curso/staging',
    'input': 'gs://template_dataflow_curso/entrada/voos_sample.csv',
    'temp_location': 'gs://template_dataflow_curso/staging',
    'template_location': 'gs://template_dataflow_curso/template/streaming_job_voos',
    'streaming' : True }
pipeline_options = PipelineOptions.from_dictionary(pipeline_options)
p1 = beam.Pipeline(options=pipeline_options)

serviceAccount = r'C:\Users\cassi\Google Drive\GCP\Dataflow Course\testes\dataflowproject-299811-5207946866a4.json'
os.environ["GOOGLE_APPLICATION_CREDENTIALS"]= serviceAccount

subscription = 'projects/dataflowproject-299811/subscriptions/MinhaSubs'
topic = 'projects/dataflowproject-299811/topics/saida'

class split_lines(beam.DoFn):
  def process(self,record):
    return [record.split(',')]

class Filter(beam.DoFn):
  def process(self,record):
    if int(record[8]) > 0:
      return [record]


pcollection_input = (
    p1  | 'Read from pubsub topic' >> beam.io.ReadFromPubSub(subscription= subscription)
)

Delayed_time = (
  pcollection_input
#  p1
#  | "Import Data time" >> beam.io.ReadFromText(r"gs://template_dataflow_curso/entrada/voos_sample.csv", skip_header_lines = 1)
  | "Split by comma time" >> beam.ParDo(split_lines())
  | "Filter Delays time" >> beam.ParDo(Filter())
  | "Create a key-value time" >> beam.Map(lambda record: (record[4],int(record[8])))
  | "Sum by key time" >> beam.CombinePerKey(sum)
#  | "Print Results" >> beam.Map(print)
)

Delayed_num = (
  pcollection_input
#  p1
#  |"Import Data" >> beam.io.ReadFromText(r"gs://template_dataflow_curso/entrada/voos_sample.csv", skip_header_lines = 1)
    | "Split by comma" >> beam.ParDo(split_lines())
    | "Filter Delays" >> beam.ParDo(Filter())
    | "Create a key-value" >> beam.Map(lambda record: (record[4],int(record[8])))
    | "Count by key" >> beam.combiners.Count.PerKey()
#   | "Print Results" >> beam.Map(print)
)

Delay_table = (
    {'Delayed_num':Delayed_num,'Delayed_time':Delayed_time} 
    | "join" >> beam.CoGroupByKey()
#    | beam.Map(print)
#    | beam.io.WriteToText(r"gs://template_dataflow_curso/saida/Voos_atrados_qtd.csv")
    | "Converting to byte String" >> beam.Map(lambda row: (''.join(row).encode('utf-8')) )
    | "Writting to Topic" >> beam.io.WriteToPubSub(topic)
)

p.run()
