#!/bin/bash
MAX_CPU_CHARES=1024
MIN_CPU_CHARES=128
MAX_LOAD_THRESHOLD=80
MIN_LOAD_THRESHOLD=70
DURATION=300

usage="$(basename "$0") [-h] [-d Duration in seconds]"
options=':hd:'
while getopts $options option; do
  case "$option" in
    h) echo "$usage"; exit;;
    d) DURATION=$OPTARG;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
  esac
done

# Function that will get executed when the user presses Ctrl+C
function shutdown(){
    echo "Shutting down..."
    docker-compose down
    exit 0
}

trap shutdown SIGINT

# Number of processing units
PU=$(nproc)

# Spin up the stack
docker-compose up --force-recreate --build -d

# Allow some time for all services to be up and running
sleep 10


echo "load_perc, portal_shares, portal_cpu_usage, stress_cpu_uasge" > out.csv

SECONDS=0
while [ $SECONDS -lt $DURATION ]; 
do
    LOAD=$(cut -d" " -f1-1 /proc/loadavg)
    LOAD=${LOAD%.*}
    #LOAD=14
    LOAD=$(($LOAD * 100))
    P=$(($LOAD / $PU))


# need to ignore if no data is returned
    PORTAL_CPU_USAGE=$(curl -X POST -s localhost:9090/api/v1/query \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "query=sum by (name) (rate(container_cpu_usage_seconds_total{name='portal'}[1m]))" | jq -r .data.result[0].value[1])
    STRESS_CONTAINER_CPU_USAGE=$(curl -X POST -s localhost:9090/api/v1/query \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "query=sum by (name) (rate(container_cpu_usage_seconds_total{name='stress-container'}[1m]))" | jq -r .data.result[0].value[1])        
    PORTAL_CPU_SHARES=$(curl -X POST -s localhost:9090/api/v1/query \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "query=container_spec_cpu_shares{name='portal'}" | jq -r .data.result[0].value[1])

    echo "SECONDS $SECONDS | LOAD $LOAD | LOAD PERC $P | PORTAL SHARES $PORTAL_CPU_SHARES | PORTAL_CPU_USAGE $PORTAL_CPU_USAGE | STRESS_CONTAINER_CPU_USAGE $STRESS_CONTAINER_CPU_USAGE"

    if (( P >= $MAX_LOAD_THRESHOLD && $PORTAL_CPU_SHARES == $MAX_CPU_CHARES  )); then
        echo "Decreasing Portal CPU shares"
        #docker update --cpu-shares="$MIN_CPU_CHARES" portal
    elif (( P < $MIN_LOAD_THRESHOLD && $PORTAL_CPU_SHARES == $MIN_CPU_CHARES  )); then
        echo "Increasing Portal CPU shares"
        #docker update --cpu-shares="$MAX_CPU_CHARES" portal
    else
        echo "NO CHANGE!!"
    fi

    echo "$P, $PORTAL_CPU_SHARES, $PORTAL_CPU_USAGE, $STRESS_CONTAINER_CPU_USAGE" >> out.csv

	sleep 2
done


shutdown