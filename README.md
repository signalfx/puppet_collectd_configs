# puppet_collectd_configs
This module configures your collectd to send metrics to SignalFx.

##### Pre-requisites
  1. Puppet module for collectd (available at pdxcat/collectd)

Collectd metrics are sent to SignalFx using the write_http plugin for collectd and this module configures the write_http plugin accordingly.

In order to send data, edit the **manifests/params.pp** file to insert your api-token.

You can also set custom dimensions on all of the metrics being sent by the collectd to SignalFx. This can be done by entering your custom dimensions into the dimension_list hash map.

