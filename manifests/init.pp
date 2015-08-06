class send_collectd_metrics(

        $api_token = "", # (required parameter)
	$dimension_list = {},
	$set_aws_instanceId = false,
	$signalfx_url = "https://ingest.signalfx.com/v1/collectd"
) {
	include 'collectd'
        
        $dimensions = get_dimensions($dimension_list, $set_aws_instanceId)
        
        $url = "${signalfx_url}${dimensions}"

	notify {"Collectd will transmit metrics to this url: ${url}":}

        class { 'collectd::plugin::write_http':
            urls => {
               "${url}"  => { 'user' => "auth", 'password' => $api_token, 'format' => 'JSON' },
            },
            notify => Service['collectd'],
        }
}
