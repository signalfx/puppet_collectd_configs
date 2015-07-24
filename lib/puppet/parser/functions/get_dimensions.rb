Puppet::Parser::Functions.newfunction(:get_dimensions, :type => :rvalue) do |args|
dimension_list = args[0]
set_aws_instanceId = args[1]
DIMENSIONS = "?"
if set_aws_instanceId
        puts "Getting AWS instance ID..."
	uri = URI.parse("http://169.254.169.254/latest/meta-data/instance-id")
        http = Net::HTTP.new(uri.host, uri.port)
        http.open_timeout = 4
        http.read_timeout = 4
        begin
                http.start
                begin
                        response = http.request(Net::HTTP::Get.new(uri.request_uri))
                rescue Timeout::Error
			puts "ERROR: Unable to get AWS instance ID, Timeout due to reading"
                end
        rescue Timeout::Error
                puts "ERROR: Unable to get AWS instance ID, Timeout due to connecting"
        end
        unless response.nil? || response == 0
                DIMENSIONS << "sfxdim_InstanceId=#{response.body}&"
        end
end
unless dimension_list.empty?
        dimension_list.each {|key, value| DIMENSIONS << "sfxdim_#{key}=#{value}&"}
end
DIMENSIONS[0...-1]
end
