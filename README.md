I need a priority container that has burstable traffic and has the priority

sum(rate(container_cpu_usage_seconds_total{name="portal"}[1m]))

sum by (name)(rate(container_cpu_usage_seconds_total{name=~"stress-container|priority-container|portal"}[1m]))


container_cpu_load_average_10s{name=~"stress-container|priority-container|portal"}


container_memory_usage_bytes{name=~"stress-container|priority-container|portal"}

https://www.metricfire.com/blog/top-10-cadvisor-metrics-for-prometheus/

https://portal.nutanix.com/page/documents/kbs/details?targetId=kA07V000000LX7xSAG



apt install fio

# would mean that 30% of the I/O will be reads and 70% will be writes.
fio --name /tmp/test --rwmixread=30 --direct=1 --size=16Gb --bs=1M --numjobs=8 --iodepth=8 --group_reporting

 --runtime=60 --startdelay=60



https://www.reddit.com/r/zfs/comments/2zaz04/when_does_sequential_io_become_random/
"If you're transcoding, CPU is going to almost certainly be your limitation."


cat out-19.json | jq .jobs[0].job_runtime


for f in ./out*.json; do cat $f | jq .jobs[0].job_runtime ; done



nproc