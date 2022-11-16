# Stacking Portal Containers

### Dependencies

* docker-compose (at least version 1.29)

apt  install docker-compose  # 


### Execution

./quick-start.sh []
To run a test with dynamic threshold adjustments 
`./quick-start.sh  -d [DURATION OF TEST IN SECONDS] -o [OUTPUT FILE]`

To run a test without the dynamic threshold adjustments, pass in the `-n` flag on the command line.


### Test Parameters

Test parameters can be found in the docker-compose.yml file and can be adjusted to cate for your system specifications

JOBS: 3
        USE_NICE: 1
    cap_add:
      - SYS_NICE
  stress-container:
    container_name: stress-container
    build:
      context: ./stress-container
      args:
        CPUS: 14