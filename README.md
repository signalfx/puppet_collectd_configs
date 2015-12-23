
# puppet_send_collectd_metrics

#### Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with send_collectd_metrics](#setup)
    * [What send_collectd_metrics affects](#what-send_collectd_metrics-affects)
3. [Usage - Configuration options and additional functionality](#usage)

## Overview

The send_collectd_metrics module configures collectd's write_http plugin to send metrics to [SignalFx](http://signalfx.com).

This is one of three modules provided by SignalFx for managing collectd. 

Module name | Description 
------------| ------------
[puppet_install_collectd](https://forge.puppetlabs.com/signalfx/install_collectd) | Install and stay up-to-date with SignalFx's latest build of collectd. 
[configure_collectd_plugins](https://forge.puppetlabs.com/signalfx/configure_collectd_plugins) | Enable and configure a set of collectd plugins that work well with SignalFx. 
send_collectd_metrics | Configure collectd to send metrics to SignalFx. 

## Setup
Install the latest release of send_collectd_metrics module from SignalFx using:
```shell
puppet module install signalfx/send_collectd_metrics
```

### What send_collectd_metrics affects

The send_collectd_metrics module configures collectd's write_http plugin to send metrics to SignalFx. You must have collectd installed in order to use this module. 

SignalFx provides additional modules to install collectd and configure data collection plugins. See [Overview](#overview). 

## Usage

The send_collectd_metrics module accepts parameters to configure the write_http plugin as follows:
```shell
class {'send_collectd_metrics':
    api_token             => "<YOUR-API-TOKEN>",
    dimension_list        => {"key" => "value"},
    aws_integration       => true,
    signalfx_url          => "https://ingest.signalfx.com/v1/collectd",
    write_http_timeout    => 3000,
    write_http_buffersize => 4096,
    ensure_plugin_version => present,
    ppa                   => "ppa:signalfx/collectd-plugin-release",
}
```
Parameter name | Description |
---------------|--------------
api_token | Provide your SignalFx API token in this parameter to send data to SignalFx. 
dimension_list | Use the dimension_list hash map to set custom dimensions on all of the metrics that collectd sends to SignalFx. For example, you can use a custom dimension to indicate that one of your servers is running Kafka by including it in the hash map as follows: `dimension_list => {"serverType" => "kafka"}`
aws_integration | This parameter controls AWS metadata syncing to SignalFx. To disable AWS metadata syncing, set this parameter to false.
signalfx_url | If you use a proxy to send metrics to SignalFx, replace this parameter with the URL of your proxy.
write_http_timeout | sets Timeout option of write_http plugin of collectd.
write_http_buffersize | sets BufferSize option of write_http plugin of collectd.
ensure_plugin_version | This parameter controls the version of signalfx plugin installation. You can specify "latest" if you want to update your plugin. You can also specify "\<version-number\>" to get the exact version from your local PPA.
ppa | Change this value if you want to install the signalfx plugin from your local PPA.





