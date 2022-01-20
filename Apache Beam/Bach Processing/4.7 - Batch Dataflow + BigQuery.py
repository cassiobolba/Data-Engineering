import apache_beam as beam
import os
from apache_beam.options.pipeline_options import PipelineOptions

pipeline_options = {
    'project': 'dataflow-course-319517' ,
    'runner': 'DataflowRunner',
    'region': 'southamerica-east1',
    'staging_location': 'gs://dataflow-course/temp',
    'temp_location': 'gs://dataflow-course/temp',
    'template_location': 'gs://dataflow-course/template/batch_job_df_bq_flights' ,
    'save_main_session': True 
    }

pipeline_options = PipelineOptions.from_dictionary(pipeline_options)
p1 = beam.Pipeline(options=pipeline_options)

serviceAccount = r"C:\Users\cassi\Google Drive\GCP\Dataflow Course\Meu_Curso_EN\dataflow-course-319517-4f98a2ce48a7.json"
os.environ["GOOGLE_APPLICATION_CREDENTIALS"]= serviceAccount

class split_lines(beam.DoFn):
  def process(self,record):
    return [record.split(',')]

class Filter(beam.DoFn):
  def process(self,record):
    if int(record[8]) > 0:
      return [record]

def dict_level1(record):
    dict_ = {} 
    dict_['airport'] = record[0]
    dict_['list'] = record[1]
    return(dict_)

def unnest_dict(record):
    def expand(key, value):
        if isinstance(value, dict):
            return [ (key + '_' + k, v) for k, v in unnest_dict(value).items() ]
        else:
            return [ (key, value) ]
    items = [ item for k, v in record.items() for item in expand(k, v) ]
    return dict(items)

def dict_level0(record):
    dict_ = {} 
    dict_['airport'] = record['airport']
    dict_['list_Delayed_num'] = record['list_Delayed_num'][0]
    dict_['list_Delayed_time'] = record['list_Delayed_time'][0]
    return(dict_)

table_schema = 'airport:STRING, list_Delayed_num:INTEGER, list_Delayed_time:INTEGER'
table = 'dataflow-course-319517:flights_dataflow.flights_aggr'

Delayed_time = (
  p1
  | "Import Data time" >> beam.io.ReadFromText(r"gs://dataflow-course/input/flights_sample.csv", skip_header_lines = 1)
  | "Split by comma time" >> beam.ParDo(split_lines())
  | "Filter Delays time" >> beam.ParDo(Filter())
  | "Create a key-value time" >> beam.Map(lambda record: (record[4],int(record[8])))
  | "Sum by key time" >> beam.CombinePerKey(sum)
)

Delayed_num = (
  p1
  |"Import Data" >> beam.io.ReadFromText(r"gs://dataflow-course/input/flights_sample.csv", skip_header_lines = 1)
  | "Split by comma" >> beam.ParDo(split_lines())
  | "Filter Delays" >> beam.ParDo(Filter())
  | "Create a key-value" >> beam.Map(lambda record: (record[4],int(record[8])))
  | "Count by key" >> beam.combiners.Count.PerKey()
)

Delay_table = (
    {'Delayed_num':Delayed_num,'Delayed_time':Delayed_time} 
    | "Group By" >> beam.CoGroupByKey()
    | "Unnest 1" >> beam.Map(lambda record: dict_level1(record))
    | "Unnest 2" >> beam.Map(lambda record: unnest_dict(record))
    | "Unnest 3" >> beam.Map(lambda record: dict_level0(record)) 
    | "Write to BQ" >> beam.io.WriteToBigQuery(
                              table,
                              schema=table_schema,
                              write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND,
                              create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED,
                              custom_gcs_temp_location = 'gs://dataflow-course/temp' )

)

p1.run()