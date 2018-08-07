FROM fluent/fluentd
RUN apk add ruby-dev && apk add g++ && apk add make
RUN gem install fluent-plugin-concat && gem install fluent-plugin-elasticsearch:2.10.1 && gem install fluent-plugin-rewrite-tag-filter && gem install fluent-plugin-kubernetes_metadata_filter:2.0.0

# Run in quiet mode (only errors)
#CMD exec fluentd -qq -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT

# Run in debug mode (warnings as well)
CMD exec fluentd -v -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT
