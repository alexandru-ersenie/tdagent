# tdagent
TDAgent Docker Image for testing with synthetic data
For testing purposes we will  use a derived fluent, installing custom plugins (concat) image that runs as a daemon, listening on port 24224
This docker image will be fed with your own fluent.conf file , that will be mounted using volumes

For more debugging increase log level when building the docker file by configuring the start flag (-qq for less debugging)

### Build image

```docker build -t fluent:local .```

### Set output in fluent configuration file

Output in standard out or kibana can be set by modifying the "match" directive in fluent.conf
There can be only one output, so instead of removing the match directive, just change the wildcard
for the other (instead of loggf set to logdummy)

#### Output to standard out
```
<match loggf.**>
  @type stdout
</match>
```

#### Output to elasticsearch

```
<match loggf.**>
   @type elasticsearch
   @log_level info
   id_key _hash # specify same key name which is specified in hash_id_key
   remove_keys _hash # Elasticsearch doesn't like keys that start with _
   include_tag_key true
   host "elastic.minikube.com"
   port "30080"
   scheme "#{ENV['FLUENT_ELASTICSEARCH_SCHEME'] || 'http'}"
   user "#{ENV['FLUENT_ELASTICSEARCH_USER'] || 'elastic'}"
   password "#{ENV['FLUENT_ELASTICSEARCH_PASSWORD'] || 'changeme'}"
   reload_connections "#{ENV['FLUENT_ELASTICSEARCH_RELOAD_CONNECTIONS'] || 'true'}"
   logstash_prefix "#{ENV['FLUENT_ELASTICSEARCH_LOGSTASH_PREFIX'] || 'logstash'}"
   logstash_format true
   #template_name "logstash-eoc"
   #template_file "/etc/td-agent/template/logstash-eoc.json"
   template_overwrite true
buffer_chunk_limit 8M
   buffer_queue_limit 64
   flush_interval 30s
   max_retry_wait 10s
   num_threads 8
   # Disable the limit on the number of retries (retry forever).
   disable_retry_limit
</match>

```
### Run image

```docker run -it -p 24224:24224 -v $(pwd)/fluent.conf:/fluentd/etc/fluent.conf fluent:local```
