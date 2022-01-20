import apache_beam as beam

words=['quatro','um']

def FindWords( i ):
 if i in words:
    return True

p1 = beam.Pipeline()

Collection = (
    p1
    |beam.io.ReadFromText('Poem.txt')
    |beam.FlatMap(lambda record: record.split(' '))
    |beam.Filter(FindWords)
    |beam.io.WriteToText('results.txt')
)
p1.run()