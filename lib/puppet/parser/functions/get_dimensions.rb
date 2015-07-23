Puppet::Parser::Functions.newfunction(:get_dimensions, :type => :rvalue) do |args| 
dimension_list = args[0]
set_aws_instanceId = args[1]
DIMENSIONS = "?"
if set_aws_instanceId
	uri = URI.parse("http://169.254.169.254/latest/meta-data/instance-id")
	response = Net::HTTP.post_form(uri, {})
	DIMENSIONS << "sfxdim_InstanceId=#{response.body}&"	
end
unless dimension_list.empty? 
dimension_list.each {|key, value| DIMENSIONS << "sfxdim_#{key}=#{value}&"}
end
DIMENSIONS[0...-1]
end
