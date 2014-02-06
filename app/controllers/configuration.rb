require_relative '../../lib/spirit/repository'

Spirit::App.controllers :configuration do

  # Dump server configuration for the admin client
  get '/get' do
    settings.server.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

  # Get repository info and mount command
  # Usually run by the runtime when it boots
  get '/get/repository' do
    client_ip = params[:client_ip] # TODO: repositories may be filtered depending on client ip?

    repository_uri = URI.parse(settings.server['repository']['url'])

    repo_hash = Spirit::Repository.make repository_uri, settings.server['repository']['user'], settings.server['repository']['password']

    logger.info "Sending repository info: %s" % repo_hash
    repo_hash.to_plist(plist_format: CFPropertyList::List::FORMAT_XML, convert_unknown_to_string: true)
  end

  post '/set' do
    500 # Not implemented
  end
end