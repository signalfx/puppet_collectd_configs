# This module that configures write_http plugin of collectd
# to send the system metrics to SignalFx
#
class send_collectd_metrics (
  $api_token,
  $dimension_list            = {},
  $aws_integration           = true,
  $signalfx_url              = 'https://ingest.signalfx.com/v1/collectd',
  $ensure_plugin_version     = present,
  $ppa                       = 'ppa:signalfx/collectd-plugin-release'
) {

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

  send_collectd_metrics::check_facter_and_osfamily {'SCM - checking facter_version':}

  $dimensions = get_dimensions($dimension_list, $aws_integration)
  $url        = "${signalfx_url}${dimensions}"
  notify {"Collectd will transmit metrics to this url: ${url}":}

  install_collectd::collectd_utils {'SCM - check for collectd installation':}

  send_collectd_metrics::install_and_configure_signalfx_plugin {
  'SCM - install plugin':}

  # configure write_http plugin
  class { 'collectd::plugin::write_http':
      urls => {
      "${url}" => {
        'user'     => 'auth',
        'password' => $api_token,
        'format'   => 'JSON'
      },
      },
  }
}
