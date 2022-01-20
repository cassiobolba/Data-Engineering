#pip install google-cloud-pubsub

import csv
import time
from google.cloud import pubsub_v1
import os

service_account_key = r'C:\Users\cassi\Google Drive\GCP\Dataflow Course\testes\dataflowproject-299811-5207946866a4.json'
os.environ["GOOGLE_APPLICATION_CREDENTIALS"]= service_account_key

topic = 'projects/dataflowproject-299811/topics/MeuTopico'
publisher = pubsub_v1.PublisherClient()

input = r"C:\Users\cassi\Google Drive\GCP\Dataflow Course\Meu_Curso\Seção 3 - Principais Transfromações\voos_sample.csv"

with open(input, 'rb') as file:
    for row in file:
        print('Publishing in Topic')
        publisher.publish(topic,row)
        time.sleep(1)