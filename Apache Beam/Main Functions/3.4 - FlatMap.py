import apache_beam as beam

p1 = beam.Pipeline()

Collection = (
    p1
    |beam.io.ReadFromText('poem.txt')
    |beam.FlatMap(lambda record: record.split(' '))
    |beam.io.WriteToText('result.txt')
)
p1.run()