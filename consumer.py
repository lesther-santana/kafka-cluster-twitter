import sys
from kafka import KafkaConsumer

if len(sys.argv) != 3:
    print('Invalid input try again!')
    exit()

consumer = KafkaConsumer(
    sys.argv[2],
    bootstrap_servers=f'{sys.argv[1]}:9092', 
    group_id='group_1',
    auto_offset_reset='earliest',
    enable_auto_commit=False
)

for msg in consumer:
    print(f"{msg.topic}:{msg.partition}:{msg.offset}: key={msg.key} value={msg.value}")