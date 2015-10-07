# installs the SignalFx repositories on your system
#
class send_collectd_metrics::install_repo inherits send_collectd_metrics::repo_params {

  case $::osfamily {
          'Debian': {
              exec { 'add SignalFx collectd-plugin ppa to software sources':
                  # software-properties-common is the source package for
                  # add-apt-repository command (after Ubuntu 13.10)
                  # python-software-properties is the source package for
                  # add-apt-repository command (before Ubuntu 13.10)
                  command    => 'apt-get update &&
                                 apt-get -y install software-properties-common &&
                                 apt-get -y install python-software-properties &&
                                 add-apt-repository ppa:signalfx/collectd-plugin-release &&
                                 apt-get update',
              }
          }

          'Redhat':{

              if $::operatingsystemmajrelease == '5' {
                      exec { 'install SignalFx collectd plugin repo  on centos 5':
                      command     => "yum -y install wget &&
                                     wget ${send_collectd_metrics::repo_params::repo_source} &&
                                     yum -y install --nogpgcheck ${send_collectd_metrics::repo_params::repo_name} &&
                                     rm -f ${send_collectd_metrics::repo_params::repo_name}"
                      }
              }
              else {
                      package { $send_collectd_metrics::repo_params::repo_name:
                              ensure      => latest,
                              provider    => 'rpm',
                              source      => $send_collectd_metrics::repo_params::repo_source
                      }
              }
          }
          default: {
              if versioncmp($::facterversion, '1.6.18') <= 0 and $::operatingsystem == 'Amazon' {
                fail("Your facter version ${::facterversion} is not supported by our module. More info can be found at https://support.signalfx.com/hc/en-us/articles/205675369")
              }
              else {
                fail("Your osfamily : ${::osfamily} is not supported.")
              }
          }
  }
      
}
