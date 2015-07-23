class send_metrics(

        $api_token = "YOUR-API-TOKEN",
	$dimension_list = {},
	$set_aws_instanceId = false

) {
	include 'collectd'
        
	$URL_BASE = 'https://ingest.signalfx.com/v1/collectd'
        
        $DIMENSIONS = get_dimensions($dimension_list, $set_aws_instanceId)
        
        $URL = "${URL_BASE}${DIMENSIONS}"

	notify {"The new URL is ${URL}":}

        class { 'collectd::plugin::write_http':
            urls => {
               "${URL}"  => { 'user' => "auth", 'password' => $api_token, 'format' => 'JSON' },
            },
            notify => Service['collectd'],
        }
}
