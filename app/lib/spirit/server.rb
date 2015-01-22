require 'socket'
require 'uri'

require_relative 'script'
require_relative 'master'
require_relative 'package'
require_relative 'workflow'

module Spirit

  class Server

    attr_accessor :spirit_config

    def initialize(spirit_config)
      @spirit_config = spirit_config
    end

    def info(request)

      repo_uri = URI.parse(@spirit_config.server['repository']['url'])
      repository_uri_preview = "%s://%s:*@%s%s" % [repo_uri.scheme, @spirit_config.server['repository']['user'], repo_uri.hostname, repo_uri.path]

      host_name = request.host

      info = {
          'computer_primary_key' => @spirit_config.server['repository']['hostPrimaryKey'],
          'host_ip' => '127.0.0.1', # TODO: Get IP from Rack
          'host_name' => host_name,
          'host_system_version' => '9', # System minor version (9 = 10.9)
          'multicast_client_datarate_min' => @spirit_config.server['multicast']['minimumClientDataRate'],
          'multicast_stream_datarate_max' => @spirit_config.server['multicast']['maximumDataRatePerStream'],
          'name' => 'Spirit Server',
          'network_interfaces' => {
              'en0' => 'Ethernet' # TODO: System interfaces from Rack?
          },
          'protocol-version' => @spirit_config.server['version'],
          'repository_url_preview' => repository_uri_preview,
          'role' => @spirit_config.server['role'], # master | ?
          'secure_server' => 'NO', # TODO: make true if ssl certificate configured
          'status' => 0, # TODO: Not sure how this is applicable
          'version' => @spirit_config.version,
          'version-string' => 'Spirit Server 1.6.12.1',
          'server_url' => request.base_url
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