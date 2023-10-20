
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kafka Version Mismatch Across Brokers.
---

This incident type refers to a situation where the different brokers in a Kafka cluster are running different versions of the software. This can lead to compatibility issues and potentially cause failures in the overall system. It is important to ensure that all brokers are running the same version of Kafka to avoid any version mismatch related incidents.

### Parameters
```shell


export BROKER_LIST="PLACEHOLDER"

export CONTROLLER_BROKER="PLACEHOLDER"

export ANY_TOPIC="PLACEHOLDER"

export TARGET_VERSION="PLACEHOLDER"

export BROKER_HOST="PLACEHOLDER"
```

## Debug

### Connect to the cluster and list all brokers
```shell
kafka-topics.sh --bootstrap-server ${BROKER_LIST} --list
```

### Check the version of Kafka running on each broker
```shell
kafka-broker-api-versions.sh --bootstrap-server ${BROKER_LIST}
```

### Compare the version of Kafka running on each broker
```shell
kafka-broker-api-versions.sh --bootstrap-server ${BROKER_LIST} | grep version
```

### Check if there are any incompatible API versions between brokers
```shell
kafka-broker-api-versions.sh --bootstrap-server ${BROKER_LIST} | grep -i incompatible
```

### Check the version of Kafka running on the controller
```shell
kafka-topics.sh --bootstrap-server ${CONTROLLER_BROKER} --describe --topic ${ANY_TOPIC}
```

### Check if the controller is up-to-date with the version of Kafka running on the brokers
```shell
kafka-broker-api-versions.sh --bootstrap-server ${CONTROLLER_BROKER} | grep -i version
```

## Repair

### Upgrade the broker(s) running the older version of Kafka to the target version.
```shell


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


```