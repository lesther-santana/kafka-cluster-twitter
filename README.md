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

``` bash
bash start.sh
```

### Stop
To stop all services, in the manager run as the root user:

```
bash stop.sh
```
