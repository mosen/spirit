require 'socket'
require 'uri'

require_relative 'script'
require_relative 'master'
require_relative 'package'
require_relative 'workflow'

module Spirit

  class Server

    attr_accessor :config

    def initialize(config)
      @config = config
    end

    def info

      repo_uri = URI.parse(@config['repository']['url'])
      repository_uri_preview = "%s://%s:*@%s%s" % [repo_uri.scheme, @config['repository']['user'], repo_uri.hostname, repo_uri.path]

      {
          'computer_primary_key' => @config['repository']['hostPrimaryKey'],
          'host_ip' => '127.0.0.1', # TODO: Get IP from Rack
          'host_name' => Socket.gethostname,
          'host_system_version' => '9', # System minor version (9 = 10.9)
          'multicast_client_datarate_min' => @config['multicast']['minimumClientDataRate'],
          'multicast_stream_datarate_max' => @config['multicast']['maximumDataRatePerStream'],
          'name' => 'Spirit Server',
          'network_interfaces' => {
              'en0' => 'Ethernet' # TODO: System interfaces from Rack?
          },
          'protocol_version' => @config['version'],
          'repository_url_preview' => repository_uri_preview,
          'role' => @config['role'],
          'secure_server' => false, # TODO: make true if ssl certificate configured
          'status' => 0, # TODO: Not sure how this is applicable
          'version' => '1.6.11',
          'version-string' => 'Spirit Server 1.6.11.1'
      }
    end

    def stats
      data = {
          'clients' => 0,
          'computers' => 0,
          'masters' => Master.all_dict.length,
          'packages' => Package.all_dict.length,
          'scripts' => Script.all.length,
          'workflows' => Workflow.all_dict.length
      }
    end

  end

end