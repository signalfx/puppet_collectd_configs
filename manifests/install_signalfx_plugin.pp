# Install signalfx collectd plugin

class send_collectd_metrics::install_signalfx_plugin (
    $ensure,
    $ppa,
) inherits send_collectd_metrics::repo_params {
    
    case $::osfamily {
            'Debian': {
                    if !('ppa:signalfx' in $ppa) {
                        exec { 'add apt-key':
                          command => 'apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68EA6297FE128AB0',
                          before  => Exec['add SignalFx collectd-plugin ppa to software sources']
                        }
                    }
                    exec { 'add SignalFx collectd-plugin ppa to software sources':
                        # software-properties-common is the source package for
                        # add-apt-repository command (after Ubuntu 13.10)
                        # python-software-properties is the source package for
                        # add-apt-repository command (before Ubuntu 13.10)
                        command    => "apt-get update &&
                                       apt-get -y install software-properties-common &&
                                       apt-get -y install python-software-properties &&
                                       add-apt-repository ${ppa} &&
                                       apt-get update",
                    }
                    package { 'signalfx-collectd-plugin':
                            ensure  => $ensure,
                            require => Exec['add SignalFx collectd-plugin ppa to software sources']
                    }
            }

            'Redhat': {
                    package { $send_collectd_metrics::repo_params::repo_name:
                      ensure   => latest,
                      provider => 'rpm',
                      source   => $send_collectd_metrics::repo_params::repo_source
                    }
                    package { 'collectd-python':
                      ensure  => installed
                    }
                    package { 'signalfx-collectd-plugin':
                            ensure   => $ensure,
                            provider => 'yum',
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
