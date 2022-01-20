import apache_beam as beam
import os
from apache_beam.options.pipeline_options import PipelineOptions

pipeline_options = {
    'project': 'dataflow-course-319517' ,
    'runner': 'DataflowRunner',
    'region': 'southamerica-east1',
    'staging_location': 'gs://dataflow-course/temp',
    'temp_location': 'gs://dataflow-course/temp',
    'template_location': 'gs://dataflow-course/template/batch_job_df_gcs_flights' 
    }
    
pipeline_options = PipelineOptions.from_dictionary(pipeline_options)
p1 = beam.Pipeline(options=pipeline_options)

serviceAccount = r"C:\Users\cassi\Google Drive\GCP\Dataflow Course\Meu_Curso_EN\dataflow-course-319517-4f98a2ce48a7.json"
os.environ["GOOGLE_APPLICATION_CREDENTIALS"]= serviceAccount

class Filter(beam.DoFn):
  def process(self,record):
    if int(record[8]) > 0:
      return [record]

Delayed_time = (
  p1
  | "Import Data time" >> beam.io.ReadFromText(r"gs://dataflow-course/input/flights_sample.csv", skip_header_lines = 1)
  | "Split by comma time" >> beam.Map(lambda record: record.split(','))
  | "Filter Delays time" >> beam.ParDo(Filter())
  | "Create a key-value time" >> beam.Map(lambda record: (record[4],int(record[8])))
  | "Sum by key time" >> beam.CombinePerKey(sum)
)

Delayed_num = (
  p1
  |"Import Data" >> beam.io.ReadFromText(r"gs://dataflow-course/input/flights_sample.csv", skip_header_lines = 1)
    | "Split by comma" >>  beam.Map(lambda record: record.split(','))
    | "Filter Delays" >> beam.ParDo(Filter())
    | "Create a key-value" >> beam.Map(lambda record: (record[4],int(record[8])))
    | "Count by key" >> beam.combiners.Count.PerKey()
)

Delay_table = (
    {'Delayed_num':Delayed_num,'Delayed_time':Delayed_time} 
    | "Group By" >> beam.CoGroupByKey()
    | "Save to GCS" >> beam.io.WriteToText(r"gs://dataflow-course/output/flights_output.csv")
)

p1.run()