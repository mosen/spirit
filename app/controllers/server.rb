require_relative '../../lib/spirit/server'

Spirit::App.controllers :server do

  # Get current date on server
  get '/get/date' do
    response = {
        'date' => Time.now.strftime('%m%d%H%M%y'), # This is a really strange date format
        'timezone' => Time.now.utc_offset
    }

    response.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

  # Get server information, including part of the configuration
  get '/get/info' do
    server = Spirit::Server.new settings.server
    server.info.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

  # Get counts for all objects in the sidebar of the admin client
  get '/get/stats' do
    serial = params[:id]

    server = Spirit::Server.new settings.server
    server.stats.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

  # TODO: stub
  get '/groups/get' do
    {}.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

  # TODO: stub
  get '/groups/get/all' do
    { 'groups' => [] }.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end


  # This normally enumerates certificates available in the keychain
  # DeployStudio installs its own com.deploystudio.server certificate and private key
  # Our equivalent would depend on whether the service was being provided through nginx or apache
  # TODO: User configuration specifies SSL Certificates
  get '/keys/get/all' do

    response = {
        'keys' => [
            'com.deploystudio.server',
            'Server Fallback SSL Certificate'
        ]
    }

    response.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

end
