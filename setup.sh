sudo apt update -y

# Install JAVA
sudo apt install default-jre -y
sudo apt install default-jdk -y

# Download and install Kafka
curl -O https://dlcdn.apache.org/kafka/3.3.1/kafka_2.13-3.3.1.tgz
tar -xzf kafka_2.13-3.3.1.tgz
mv kafka_2.13-3.3.1 /usr/local/kafka
mkdir /tmp/kafka-logs

# Zookeeper Configuration
mkdir -p /var/lib/zookeeper
# Pass zookeeper node id as command-line-argument
echo $1 > /var/lib/zookeeper/myid
mv zookeeper_ensemble.properties /usr/local/kafka/config/

# MODIFIFY BROKER ID and listeners
# Define the path for kafka and zookeeper
kafka_home="/usr/local/kafka"

sed -i "s/broker.id=0/broker.id='$i'/" "/usr/local/kafka/config/server.properties"
echo listeners=PLAINTEXT://0.0.0.0:9092 >> /usr/local/kafka/config/server.properties
echo advertised.listeners=PLAINTEXT://:9092 >> /usr/local/kafka/config/server.properties