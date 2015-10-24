# Install signalfx collectd plugin

define send_collectd_metrics::install_and_configure_signalfx_plugin {
  case $::osfamily {
    'Debian': {
      # Add apt-repository key
      $ppa = "abcd"
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
        require  => Package["${send_collectd_metrics::repo_params::repo_name}"]
      }
    }
  }
}
