# This module that configures write_http plugin of collectd 
# to send the system metrics to SignalFx
#
class send_collectd_metrics (
  $api_token,
  $dimension_list            = {},
  $aws_integration           = true,
  $signalfx_url              = 'https://ingest.signalfx.com/v1/collectd',
  $write_http_timeout        = 3000,
  $write_http_buffersize     = 4096,
  $ensure_plugin_version     = present,
  $ppa                       = 'ppa:signalfx/collectd-plugin-release',
) {
  if versioncmp($::facterversion, '1.6.18') <= 0 and $::operatingsystem == 'Amazon' {
    
    fail("Your facter version ${::facterversion} is not supported by our module. more info can be found at https://support.signalfx.com/hc/en-us/articles/205675369")
  
  }else {
  
        Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

        include 'install_collectd'

        if $::osfamily == 'Debian' {
          $conf_dir = '/etc/collectd/conf.d'
        }
        elsif $::osfamily == 'Redhat' {
          $conf_dir = '/etc/collectd.d'
        }

        # Install signalfx plugin
        class { 'send_collectd_metrics::install_signalfx_plugin':
            ensure => $ensure_plugin_version,
            ppa    => $ppa
        }

        $dimensions = get_dimensions($dimension_list, $aws_integration)
        $signalfx_url_with_dimensions = "${signalfx_url}${dimensions}"
        notify {"Collectd will transmit metrics to this url: ${signalfx_url_with_dimensions}":}

        # configure write_http plugin
        validate_integer($write_http_timeout)
        validate_integer($write_http_buffersize)
        $write_http_user = 'auth'
        $write_http_format = 'JSON'
        file { 'load write_http plugin':
          ensure  => present,
          path    => "${conf_dir}/10-write_http.conf",
          owner   => root,
          group   => 'root',
          mode    => '0640',
          content => template('send_collectd_metrics/write_http.conf.erb'),
          notify  => Service['collectd'],
          require => Class['send_collectd_metrics::install_signalfx_plugin']
        }

        # configure signalfx plugin
        file { 'load Signalfx plugin':
          ensure  => present,
          path    => "${conf_dir}/10-signalfx.conf",
          owner   => root,
          group   => 'root',
          mode    => '0640',
          content => template('send_collectd_metrics/signalfx_plugin.conf.erb'),
          notify  => Service['collectd'],
          require => Class['send_collectd_metrics::install_signalfx_plugin']
        }
  }
}

