# Filebeat Moniotoring

## Unstable Events Rate/Throughput

https://discuss.elastic.co/t/unstable-events-rate-throughput/169003

![](https://aws1.discourse-cdn.com/elastic/optimized/3X/8/7/8736d8df570585c10561a38abab6604952b27e78_2_690x387.png)

![](https://aws1.discourse-cdn.com/elastic/optimized/3X/e/a/ea4c910cc19554624264f807fd135c76a1e45c97_2_690x385.png)

I use elasticsearch and filebeat 6.5.4
My filebeat.yml configuration:
```YML
filebeat.inputs:
- type: log
  enabled: true
  paths:
  - /data/filebeat/logs/*/beat.*
  json.keys_under_root: true
  json.overwrite_keys: true
  json.add_error_key: true
  close_inactive: 1h

processors:
- drop_fields:
    fields: ["beat", "input", "offset", "prospector", "source", "host"]
- drop_event:
    when:
      not:
        has_fields: ["indexKey"]

setup.template.enabled: false
xpack.monitoring.enabled: true

queue.mem:
  events: 8192
  flush.min_events: 2048
  flush.timeout: 1s

output.elasticsearch:
  hosts: ["url_to_elasticseach"]
  username: "XXXXXX"
  password: "XXXXXX"
  index: "%{[indexKey]}-%{+yyyy.MM.dd}"
  bulk_max_size: 2048
  worker: 4

logging.level: info
logging.to_files: true
```
Thank you in advance, any help will be very appreciated!


## Filebeat 6.2 throughput and general performance

https://discuss.elastic.co/t/filebeat-6-2-throughput-and-general-performance/122422

At the moment I'm sending data from 4 new logs every minute, this is what iostat -x says (the ES node is in vdb, and there's some activity in vdd since it's copying files from vdd to vdb):
```shell
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2,27    0,00    0,29    0,58    0,00   96,85
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
vdb               0,00     3,18    7,56    5,25   585,49  2118,46   422,26     2,10  163,89   10,96  384,36   3,39   4,35
vdd               0,00     0,03    4,79    0,04   808,54     0,31   334,85  
```
