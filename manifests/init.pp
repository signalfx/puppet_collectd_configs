class send_collectd_metrics(

        $api_token = "", # (required parameter)
	$dimension_list = {},
	$set_aws_instanceId = false,
	$signalfx_url = "https://ingest.signalfx.com/v1/collectd"
) {
	include 'collectd'
        
        $DIMENSIONS = get_dimensions($dimension_list, $set_aws_instanceId)
        
        $URL = "${signalfx_url}${DIMENSIONS}"

	notify {"The new URL is ${URL}":}

        class { 'collectd::plugin::write_http':
            urls => {
               "${URL}"  => { 'user' => "auth", 'password' => $api_token, 'format' => 'JSON' },
            },
            notify => Service['collectd'],
        }
}
