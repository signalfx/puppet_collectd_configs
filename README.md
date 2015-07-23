# puppet_collectd_configs
This module configures your collectd to send metrics to SignalFx.

##### Pre-requisites
  1. Puppet module to install collectd (available at signalfx/install_collectd)

Collectd metrics are sent to SignalFx using the write_http plugin of collectd. In order to send data, insert your api-token. You can also set custom dimensions on all of the metrics being sent by the collectd to SignalFx. This can be done by entering your custom dimensions into the dimension_list hash map.

##### Usage
``` ruby
class {'::send_metrics':
    api_token => "<YOUR-API-TOKEN>",
    dimension_list => {"serverType" => "API"},
    set_aws_instanceId => true
}
```





