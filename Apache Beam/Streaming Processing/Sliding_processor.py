pip install apache_beam

pip install google-cloud-pubsub

import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions,StandardOptions
import os
from apache_beam import window
from apache_beam.transforms.combiners import Count
import time


serviceAccount = '/content/vivid-now-271806-e22933a07e8a.json'
os.environ["GOOGLE_APPLICATION_CREDENTIALS"]= serviceAccount

input_subscription = 'projects/vivid-now-271806/subscriptions/movie_subscription'

options= PipelineOptions()
options.view_as(StandardOptions).streaming= True

p = beam.Pipeline(options=options)

comedy_movies = 'projects/vivid-now-271806/topics/comedy_movies'

def format(element):
    (movie,rating)=element
    return "{r} rating for movieID {MID} in 10 seconds".format(f= rating, MID=movie).encode('utf-8')

pubsub_pipeline = (
    p
    | 'Read from pubsub topic' >> beam.io.ReadFromPubSub(subscription= input_subscription)
    # decodificar e split
    | 'Split the records by comma' >> beam.Map(lambda row: row.decode("utf-8").split(','))
    # definir a coluna, ou criar uma coluna. Criando em cada linha uma timestamp
    | 'Timestamp Customizada ' >> beam.Map(lambda row: beam.window.TimestampedValue(row, time.time()))
    # Criar um key value pair, onde indico a coluna id do filme e ratings, para contar quantas ratings recebidas por id de filme
    | 'Form Key Value Pair' >> beam.Map(lambda row: (row[1],float(row[2])))
    # defino minha janela, primeiro parametro é janela, segundo é intervalo de janelas
    | 'Window' >> beam.WindowInto(window.SlidingWindows(4,2))
    # contar ratings por chave
    | 'Count the ratings' >> Count.PerKey()
    # codificar 
    #| 'Converting to byte String' >> beam.Map(lambda row: (''.join(row).encode('utf-8')) )
    | 'format' >> beam.Map(format)
    | 'Publish to output topic' >> beam.io.WriteToPubSub(comedy_movies)
)
result = p.run()
result.wait_until_finish()