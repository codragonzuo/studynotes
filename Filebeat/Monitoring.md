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
