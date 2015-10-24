define send_collectd_metrics::check_facter_and_osfamily {

  # check for the older facter version
  if versioncmp($::facterversion, '1.6.18') <= 0 and $::operatingsystem == 'Amazon' {
    fail("Your facter version ${::facterversion} is not supported by our module. more info can be found at https://support.signalfx.com/hc/en-us/articles/205675369")
  }

  # check whether the operating system is supported
  case $::osfamily {
    'Debian': {}
    'Redhat': {}
    default: {
      fail("Your osfamily : ${::osfamily} is not supported. Failed to install signalfx-collectd-plugin")
    }
  }
}
