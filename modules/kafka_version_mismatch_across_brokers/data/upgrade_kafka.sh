

#!/bin/bash



# Set variables

BROKER_HOST=${BROKER_HOST}

TARGET_VERSION=${TARGET_VERSION}



# Stop Kafka on the target broker

'/usr/local/kafka/bin/kafka-server-stop.sh'



# Upgrade Kafka on the target broker
wget https://archive.apache.org/dist/kafka/$TARGET_VERSION/kafka_2.11-$TARGET_VERSION.tgz

tar -xzf kafka_2.11-$TARGET_VERSION.tgz

rm kafka_2.11-$TARGET_VERSION.tgz

ln -sfn kafka_2.11-$TARGET_VERSION kafka


# Start Kafka on the target broker

/usr/local/kafka/bin/kafka-server-start.sh -daemon /usr/local/kafka/config/server.properties