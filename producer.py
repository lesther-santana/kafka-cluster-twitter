import os
import sys
import tweepy
import json
from kafka import KafkaProducer
from kafka.errors import KafkaError
from dotenv import load_dotenv


TOPICS = ['tweets']

if len(sys.argv) != 4 or not str.isalpha(sys.argv[3]) or sys.argv[2] not in TOPICS:
    print('Invalid input try again!')
    exit()

load_dotenv()

target = sys.argv[3]
kafka_topic = sys.argv[2]
server = sys.argv[1]

access_token = os.getenv('ACCESS_TOKEN')
access_token_secret = os.getenv('ACCESS_TOKEN_SECRET')
consumer_key = os.getenv('CONSUMER_KEY')
consumer_secret = os.getenv('CONSUMER_SECRET')
bearer_token = os.getenv('BEARER_TOKEN')

class customClient(tweepy.StreamingClient):
    def on_data(self, raw_data):
        parsed = json.loads(raw_data)
        print(parsed["data"]["id"])
        future = producer.send(kafka_topic, raw_data)
        try:
            record_metadata = future.get(timeout=10)
            print(record_metadata)
        except KafkaError as e:
            print(e)
        producer.flush()
        return True

producer = KafkaProducer(bootstrap_servers=f'{server}:9092') #Same port as your Kafka server

streaming_client = customClient(bearer_token=bearer_token)

try:
    active_rules = [rule.id for rule in streaming_client.get_rules().data]
    streaming_client.delete_rules(active_rules)
except Exception as e:
    print(e)
    pass

rule_params = [f'{target}','lang:en', 'sample:10']
query = tweepy.StreamRule(' '.join(rule_params))

streaming_client.add_rules(query)
streaming_client.filter()