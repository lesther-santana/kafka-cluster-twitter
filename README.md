# Kafka Cluster to Store Tweets

## Environment Setup

This system runs Zookeeper as a node ensemble in the same network.

1. Add the node's IPs or hostnmames to the zookeeper_ensemble.properties. The servers are specified in the format server.X=hostname:peerPort:leaderPort, with the following parametersThe configuration might look like this:

```
server.1=zoo1.example.com:2888:3888
server.2=zoo2.example.com:2888:3888
server.3=zoo3.example.com:2888:3888
```

2. Put in the *nodes* file the cluster instances internal IP's in the following format. The manager will execute remote commands during the installation process, so every worker must have the manager's SSH key added.

```
Manager IP
Worker-1-IP
.
.
Worker-N-IP
```

3. Place zookeeper_ensemble.properties and setup.sh in each cluster node, then execute as the root setup.sh. For instance, if the manager is server.1 in the .properties file, in a terminal, as the root user, run `bash setup.sh 1`. Repeat the process for every server in the configurations file.

4. For the instances where the Producer and Consumer modules will run:

    * Install python and Pip
    * Install the necessary libraries using the *requirements.txt*.

5. Place in a .env file where the Producer runs the Consumer Keys, Authentication, and Bearer Token for the Twitter API

## Run the cluster

### Start

To start Zookeeper and then Kafka in each node. Place `nodes` and `start.sh` in the same location at the manager and then in a terminal as the root user run:

```
bash start.sh
```

### Stop
To stop all services, in the manager run as the root user:

```
bash stop.sh
```
## Connecting to Twitter API v2
Our producer application uses python and the library tweepy to connect to twitter's API v2. We use the filtered stream endpoint to listen for specific keywords. Both producer and consumer modules use kafka-python.

To start the stream, we must create a rule. Ours has three operators, "keyword," "lang: en," and "sample:10". First, the "keyword" matches a keyword within the body of a Tweet. The second is "lang:en:" to capture Tweets that Twitter has classified as being in English, and the third is "sample:10" to return a random percent sample of Tweets that match the rule rather than the entire set of Tweets. The last operator is to stay within the tweet capture cap of 2 million tweets.

### Producer
To start the producer, run `producer.py` passing 3 arguments: The first argument is the host the consumer should contact to bootstrap initial cluster metadata, the second is the Kafka topic and the third is the keyword we want to use for the stream:

```
python3 producer.py 10.128.0.14 tweets Messi
```

### Consumer

Run consumer.py passing 2 arguments. The first argument is the host the consumer should contact to bootstrap initial cluster metadata, the second is the Kafka topic:

```
python3 consumer.py 10.128.0.14 tweets
```
