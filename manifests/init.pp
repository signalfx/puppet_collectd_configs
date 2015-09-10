# This module that configures write_http plugin of collectd 
# to send the system metrics to SignalFx
#
class send_collectd_metrics (

  $api_token                 = '', # (required parameter)
  $dimension_list            = {},
  $aws_integration           = false,
  $signalfx_url              = 'https://ingest.signalfx.com/v1/collectd'
) {
  if versioncmp($::facterversion, '1.6.18') <= 0 and $::operatingsystem == 'Amazon' {
    fail("Your facter version ${::facterversion} is not supported by our module. more info can be found at https://support.signalfx.com/hc/en-us/articles/205675369")
  }else {
  
  include 'collectd'
        
        $dimensions = get_dimensions($dimension_list, $aws_integration)
        
        $url        = "${signalfx_url}${dimensions}"

        notify {"Collectd will transmit metrics to this url: ${url}":}

        class { 'collectd::plugin::write_http':
            urls      => {
            "${url}"    => {
                          'user'                       => 'auth',
                          'password'                   => $api_token,
                          'format'                     => 'JSON'
            },
            },
            notify    => Service['collectd'],
        }
  }
}
