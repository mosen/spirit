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

    repository_uri = URI.parse(settings.server.repository.url)

    repo_hash = Repository.make repository_uri, settings.server.repository.user, settings.server.repository.password
    repo_hash.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

  post '/set' do
    500 # Not implemented
  end
end
