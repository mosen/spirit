require 'yaml'
require_relative '../../lib/spirit/repository'

Spirit::App.controllers :configuration do

  # Dump server configuration for the admin client
  get '/get' do
    settings.server.to_plist(convert_unknown_to_string: false)
  end

  # Get repository info and mount command
  # Usually run by the runtime when it boots
  get '/get/repository' do
    client_ip = params[:client_ip] # TODO: repositories may be filtered depending on client ip?

    repository_uri = URI.parse(settings.server['repository']['url'])

    repo_hash = Spirit::Repository.make repository_uri, settings.server['repository']['user'], settings.server['repository']['password']

    logger.info "Sending repository info: %s" % repo_hash
    repo_hash.to_plist(convert_unknown_to_string: true)
  end

  # Set server configuration from DeployStudio Assistant
  post '/set' do
    if @request_payload['version'] == 1.0
      require 'pp'
      pp @request_payload
    else
      logger.info "Attempted to set configuration using unsupported version: %s" % @request_payload['version']
      400
    end

    # If this server is to be a replica, then the configuration will contain role: replica, and a dssmaster dict
    # with the master login/password/url and which items to sync, the sync numbers indicate 0 - no sync, 1 - sync (pull), 2 - bidir sync



    configuration_yaml = @request_payload.to_yaml
    File.open(settings.server_config_path, 'w') do |f|
      f.write configuration_yaml
    end

    201
  end
end