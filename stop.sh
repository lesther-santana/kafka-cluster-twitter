# Load nodes internal IPs to array
readarray -t nodes < ./nodes

# Define the path for kafka and zookeeper
kafka_home="/usr/local/kafka"

# Send stop commands to nodes"
for ((i=1; i < 3; i++))
do
    echo "Stopping Zookeper and Kafka Broker in ${nodes[$i]}"
    ssh ${nodes[$i]} "${kafka_home}/bin/zookeeper-server-stop.sh"
    ssh ${nodes[$i]} "${kafka_home}/bin/kafka-server-stop.sh"
done

# Do the commands in IP-1 (manager)
echo "Stopping Zookeper and Kafka Broker in ${nodes[0]}"
${kafka_home}/bin/zookeeper-server-stop.sh
${kafka_home}/bin/kafka-server-stop.sh