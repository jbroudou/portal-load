#!/bin/bash

# wait a bit so that the container can start
sleep 60

while :
do
	cpus=$(cat cpus)
	echo "Running stress-ng with $cpus CPUS ..."
	stress-ng --cpu $cpus --timeout 120s --metrics-brief
	sleep 120
done