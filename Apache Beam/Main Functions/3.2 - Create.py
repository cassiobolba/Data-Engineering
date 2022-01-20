import apache_beam as beam

p1 = beam.Pipeline()

p1 | "Tuple" >> beam.Create( [ ("Cassio",32) , ("Vics",21) ] ) | beam.Map(print) #tuple
p1 | "List" >> beam.Create ( [ 1,2,3 ] ) |  beam.Map(print) #list

p1.run()