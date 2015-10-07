# This module that configures write_http plugin of collectd 
# to send the system metrics to SignalFx
#
class send_collectd_metrics (

  $api_token                 = '', # (required parameter)
  $dimension_list            = {},
  $aws_integration           = true,
  $signalfx_url              = 'https://ingest.signalfx.com/v1/collectd'
) {
  if versioncmp($::facterversion, '1.6.18') <= 0 and $::operatingsystem == 'Amazon' {
    
    fail("Your facter version ${::facterversion} is not supported by our module. more info can be found at https://support.signalfx.com/hc/en-us/articles/205675369")
  
  }else {
  
        if $api_token == '' {
              fail('Please insert a valid API token!')
        }
        Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
    
        include 'collectd'
        
        # Install signalfx plugin
        include 'send_collectd_metrics::install_signalfx_plugin'
        include collectd::params
        $conf_dir = $collectd::params::plugin_conf_dir

        $dimensions = get_dimensions($dimension_list, $aws_integration)
        $url        = "${signalfx_url}${dimensions}"
        notify {"Collectd will transmit metrics to this url: ${url}":}

        # configure write_http plugin
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
        
        # configure signalfx plugin
        file { 'load Signalfx plugin':
          ensure  => present,
          path    => "${conf_dir}/20-signalfx_plugin.conf",
          owner   => root,
          group   => $root_group,
          mode    => '0640',
          content => template('send_collectd_metrics/signalfx_plugin.conf.erb'),
          notify  => Service['collectd'],
          require => Class['send_collectd_metrics::install_signalfx_plugin']
        }

  }
}
