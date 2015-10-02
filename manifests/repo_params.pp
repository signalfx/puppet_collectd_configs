# contains the urls and other information about SignalFx repositories

class send_collectd_metrics::repo_params {
        case $::operatingsystem {
                'Ubuntu':{}
                'CentOS': {
                        case $::operatingsystemmajrelease {
                                '7': {
                                      $repo_name       = 'SignalFx-collectd_plugin-RPMs-centos-7-release'
                                      $repo_source     = 'https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd_plugin-RPMs-centos-7-release-latest.noarch.rpm'
                                }
                                '6': {
                                      $repo_name       = 'SignalFx-collectd_plugin-RPMs-centos-6-release'
                                      $repo_source     = 'https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd_plugin-RPMs-centos-6-release-latest.noarch.rpm'
                                }
                                default: {
                                        fail("Your centos os major release : ${::operatingsystemmajrelease} is not supported.")
                                }
                        }
                }
                'Amazon': {
                        case $::operatingsystemrelease {
                                '2015.09': {
                                      $repo_name       = 'SignalFx-collectd_plugin-RPMs-AWS_EC2_Linux_2015_09-release'
                                      $repo_source     = 'https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd_plugin-RPMs-AWS_EC2_Linux_2015_09-release-latest.noarch.rpm'
                                }
                                '2015.03': {
                                      $repo_name       = 'SignalFx-collectd_plugin-RPMs-AWS_EC2_Linux_2015_03-release'
                                      $repo_source     = 'https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd_plugin-RPMs-AWS_EC2_Linux_2015_03-release-latest.noarch.rpm'
                                }
                                '2014.09': {
                                      $repo_name       = 'SignalFx-collectd_plugin-RPMs-AWS_EC2_Linux_2014_09-release'
                                      $repo_source     = 'https://dl.signalfx.com/rpms/SignalFx-rpms/release/SignalFx-collectd_plugin-RPMs-AWS_EC2_Linux_2014_09-release-latest.noarch.rpm'
                                }
                                default: {
                                  if versioncmp($::facterversion, '1.6.18') <= 0 and $::operatingsystem == 'Amazon' {
                                    fail("Your facter version ${::facterversion} is not supported by our module. More info can be found at https://support.signalfx.com/hc/en-us/articles/205675369")
                                  }else {
                                      fail("Your operating system release : ${::operatingsystemrelease} is not supported.")
                                  }
                                }
                        }
                }
                default: {
                        fail("Your operating system : ${::operatingsystem} is not supported.")
                }
        }
}
