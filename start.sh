# Load nodes internal IPs to array
readarray -t nodes < ./nodes

# Define the path for kafka and zookeeper
kafka_home="/usr/local/kafka"

# delete any data of Kafka environment including any events created along the way
for ((i=1; i < 3; i++))
do
    echo "Initializing ${nodes[$i]}"
    num=$((i+1))
    ssh ${nodes[$i]} "sudo rm -rf /tmp/kafka-logs /var/lib/zookeeper"
    ssh ${nodes[$i]} "sudo mkdir /tmp/kafka-logs"
    ssh ${nodes[$i]} "sudo mkdir -p /var/lib/zookeeper"
    ssh ${nodes[$i]} "sudo echo $num > /var/lib/zookeeper/myid"
done

# delete data in (manager)
sudo rm -rf /tmp/kafka-logs /var/lib/zookeeper
sudo mkdir /tmp/kafka-logs
sudo mkdir -p /var/lib/zookeeper
sudo echo 1 > /var/lib/zookeeper/myid

# First Start Zookeeper service
for ((i=1; i < 3; i++))
do
    echo "Initializing Zookeper in ${nodes[$i]}"
    ssh ${nodes[$i]} "${kafka_home}/bin/zookeeper-server-start.sh -daemon ${kafka_home}/config/zookeeper_ensemble.properties"
done

# Start in manager
echo "Initializing Zookeper in ${nodes[0]}"
${kafka_home}/bin/zookeeper-server-start.sh -daemon ${kafka_home}/config/zookeeper_ensemble.properties

# Second start kafka broker
for ((i=1; i < 3; i++))
do
    echo "Initializing Broker in ${nodes[$i]}"
    ssh ${nodes[$i]} "${kafka_home}/bin/kafka-server-start.sh -daemon ${kafka_home}/config/server.properties"
done

# Start in manager
echo "Initializing Broker in ${nodes[0]}"
${kafka_home}/bin/kafka-server-start.sh -daemon ${kafka_home}/config/server.properties

# See if the 3 brokers have successfully launched
echo "Cheking active brokers in cluster"
sleep 3
/usr/local/kafka/bin/zookeeper-shell.sh localhost:2181 ls /brokers/ids