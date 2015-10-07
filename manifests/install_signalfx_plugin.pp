# Install signalfx collectd plugin

class send_collectd_metrics::install_signalfx_plugin {
    
    include "send_collectd_metrics::install_repo"
    case $::osfamily {
            'Debian': {

                    package { 'signalfx-collectd-plugin':
                            ensure           => latest,
                            require          => Class['send_collectd_metrics::install_repo']
                    }
            }

            'Redhat': {
                    package { 'collectd-python':
                      ensure  => installed
                    }
                    package { 'signalfx-collectd-plugin':
                            ensure           => latest,
                            provider         => 'yum',
                            require          => Class['send_collectd_metrics::install_repo']
                    }
            }

            default: {
              if versioncmp($::facterversion, '1.6.18') <= 0 and $::operatingsystem == 'Amazon' {
                fail("Your facter version ${::facterversion} is not supported by our module. More info can be found at https://support.signalfx.com/hc/en-us/articles/205675369")
              }else {
                fail("Your osfamily : ${::osfamily} is not supported. Failed to install signalfx-collectd-plugin")
              }
            }
    }
}
