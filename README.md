
# puppet_send_collectd_metrics

#### Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with send_collectd_metrics](#setup)
    * [What send_collectd_metrics affects](#what-send_collectd_metrics-affects)
3. [Usage - Configuration options and additional functionality](#usage)

## Overview

The send_collectd_metrics module configures the write_http plugin of collectd to send your system metrics to SignalFx, a monitoring platform.

## Setup
Install the latest release of send_collectd_metrics module from SignalFx using:
```shell
puppet module install signalfx/send_collectd_metrics
```

### What send_collectd_metrics affects

The send_collectd_metrics module configures only the write_http plugin. It does not configure any other plugins.

It is recommended to include the [install_collectd](https://github.com/signalfx/puppet_install_collectd) and [configure_collectd_plugins](https://github.com/signalfx/puppet_configure_collectd_plugins) modules before this module if you don't have any existing collectd on your systems to get the latest collectd from SignalFx repositories.

## Usage

The send_collectd_metrics module accepts few parameters to configure the write_http plugin:
```shell
class {'send_collectd_metrics':
    api_token => "<YOUR-API-TOKEN>",
    dimension_list => {"key" => "value"},
    set_aws_instanceId => false,
    signalfx_url => "https://ingest.signalfx.com/v1/collectd"
}
```
 * In order to send data, insert your api-token. 
 * You can set custom dimensions on all of the metrics being sent by the collectd to SignalFx. This can be done by entering your custom dimensions into the dimension_list hash map.  
   For example: If one of your servers is running kafka, you can attach a custom dimension into the hash map as:  
   dimension_list => {"serverType" => "kafka"}
 * You can attach AWS instance id (this module pulls it automatically) by setting the set_aws_instanceId as true
 * You can also configure the target url if you choose to use a proxy to send metrics to SignalFx.





