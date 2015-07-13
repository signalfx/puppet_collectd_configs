class signalfx_collectd(

        $api_token = $signalfx_collectd::params::api_token

) inherits signalfx_collectd::params  {


	class { '::collectd':}

        $URL_BASE = 'https://ingest.signalfx.com/v1/collectd'
        
        $DIMENSIONS = get_dimensions($signalfx_collectd::params::dimension_list)
        
        $URL = "${URL_BASE}${DIMENSIONS}"
	
	notify {"The new URL is ${URL}":}

	# collectd::plugin { ['cpu', 'cpufreq', 'df', 'disk', 'interface', 'load', 'memory', 'network', 'uptime']: }
	
	class { 'collectd::plugin::logfile':
            log_level => 'info',
            log_file => '/var/log/signalfx-collectd.log',
        }

        class { 'collectd::plugin::write_http':
            urls => {
               "${URL}"  => { 'user' => "auth", 'password' => $api_token, 'format' => 'JSON' },
            },
            notify => Service['collectd'],
        }
}
