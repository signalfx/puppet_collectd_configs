# Install signalfx collectd plugin

class send_collectd_metrics::install_signalfx_plugin (
    $ensure,
    $ppa,
    $debian_ppa,
) {

    case $::osfamily {
            'Debian': {
                    if ($::operatingsystem == 'Debian'){
                        exec { 'add SignalFx public key id for signalf-collectd-plugin':
                            command => "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${send_collectd_metrics::repo_params::signalfx_public_keyid}",
                            before  => Exec['add SignalFx collectd-plugin ppa to software sources']
                        }
                        ensure_resource('package', 'apt-transport-https', {'ensure' => 'present'})
                        exec { 'add SignalFx collectd-plugin ppa to software sources':
                            command => "echo ${debian_ppa} > /etc/apt/sources.list.d/signalfx_collectd_plugin.list && 
                                        apt-get update",
                            before  => Package['signalfx-collectd-plugin'],
                            require => Package['apt-transport-https']
                        }
                    }else{
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
                            command => "apt-get update &&
                                         apt-get -y install software-properties-common &&
                                         apt-get -y install python-software-properties &&
                                         add-apt-repository ${ppa} &&
                                         apt-get update",
                            before  => Package['signalfx-collectd-plugin']
                        }
                        
                    }
                    package { 'signalfx-collectd-plugin':
                            ensure  => $ensure,
                    }
            }

            'Redhat': {
                    if ! defined( Package['collectd-python'] ) {
                      package { 'collectd-python':
                        ensure  => installed,
                      }
                    }
                    package { $send_collectd_metrics::repo_params::repo_name:
                      ensure   => latest,
                      provider => 'rpm',
                      source   => $send_collectd_metrics::repo_params::repo_source
                    }
                    package { 'signalfx-collectd-plugin':
                            ensure   => $ensure,
                            provider => 'yum',
                            require  => Package['collectd-python']
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
