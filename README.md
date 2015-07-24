# puppet_send_metrics
This module configures write_http plugin of collectd to send your system metrics to SignalFx.

##### Pre-requisites
  1. Puppet module to install collectd (available at signalfx/install_collectd)

Collectd metrics are sent to SignalFx using the write_http plugin of collectd. 
 * In order to send data, insert your api-token. 
 * You can set custom dimensions on all of the metrics being sent by the collectd to SignalFx. This can be done by entering your custom dimensions into the dimension_list hash map.
 * You can also configure the target url if you choose to use a proxy to send metrics to SignalFx.

##### Usage
``` ruby
class {'::send_metrics':
    api_token => "<YOUR-API-TOKEN>",
    dimension_list => {"serverType" => "API"},
    set_aws_instanceId => true,
    signalfx_url => "https://ingest.signalfx.com/v1/collectd"
}
```





