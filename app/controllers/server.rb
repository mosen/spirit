require_relative '../../lib/spirit/server'

Spirit::App.controllers :server do

  # Get current date on server
  get '/get/date' do
    response = {
        'date' => Time.now.strftime('%m%d%H%M%y'), # This is a really strange date format
        'timezone' => Time.now.utc_offset
    }

    response.to_plist
  end

  # Get server information, including part of the configuration
  get '/get/info' do
    server = Spirit::Server.new settings.server
    server.info(@request).to_plist
  end

  # Get counts for all objects in the sidebar of the admin client
  get '/get/stats' do
    serial = params[:id]

    server = Spirit::Server.new settings.server
    server.stats.to_plist
  end

  # When choosing groups from the directory service using the DeployStudio Assistant,
  # This is called with a ?search parameter to determine valid groups
  get '/groups/get' do
    {}.to_plist # Format is { 'groups' => ['groupname', 'DOMAIN\groupname'] }
  end

  # TODO: stub
  get '/groups/get/all' do
    { 'groups' => [] }.to_plist
  end


  # This normally enumerates certificates available in the keychain
  # DeployStudio installs its own com.deploystudio.server certificate and private key
  # Our equivalent would depend on whether the service was being provided through nginx or apache.
  # This is also responsible for giving the admin choices on which certificate to secure the service with.
  # TODO: User configuration specifies SSL Certificates
  get '/keys/get/all' do

    response = {
        'keys' => [
          'Spirit cannot set SSL certificates'
        ]
    }

    response.to_plist
  end

end
