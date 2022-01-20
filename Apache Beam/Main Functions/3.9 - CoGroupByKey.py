import apache_beam as beam

p1 = beam.Pipeline()

Delayed_time = (
p1
  | "Import Data" >> beam.io.ReadFromText("flights_sample.csv", skip_header_lines = 1)
  | "Split by comma" >> beam.Map(lambda record: record.split(','))
  | "Filter Delays" >> beam.Filter(lambda record: int(record[8]) > 0 )
  | "Create a key-value" >> beam.Map(lambda record: (record[4],int(record[8])))
  | "Sum by key" >> beam.CombinePerKey(sum)
#  | "Print Results" >> beam.Map(print)
)

Delayed_num = (
    p1
    | "Import Data Num" >> beam.io.ReadFromText("flights_sample.csv", skip_header_lines = 1)
    | "Split by comma Num" >> beam.Map(lambda record: record.split(','))
    | "Filter Delays Num" >> beam.Filter(lambda record: int(record[8]) > 0 )
    | "Create a key-value Num" >> beam.Map(lambda record: (record[4],int(record[8])))
    | "Combine by key" >> beam.combiners.Count.PerKey()
#    | "Print Results" >> beam.Map(print)
)

Delay_table = (
    {'Delayed_num':Delayed_num,'Delayed_time':Delayed_time} 
    | beam.CoGroupByKey()
    | beam.Map(print)
)

p1.run()