require 'yaml'
require 'cfpropertylist'
require 'sinatra/config_file'

module Spirit
  class App < Padrino::Application
    register Padrino::DNSSD
    register Padrino::Rendering
    register Padrino::Mailer
    register Padrino::Helpers
    register Sinatra::ConfigFile

    # Requests may come from anywhere
    set :protection, false
    set :protect_from_csrf, false
    set :allow_disabled_csrf, false

    # Configuration comes in two parts: Spirit config and DeployStudio native config
    # This ensures that my implementation isn't mixed with the native configuration.
    config_file 'config/spirit.yml'

    # DeployStudio config file - will retain the exact same structure as DS expects. Extensions are in config/spirit.yml
    # Reason: config can be written by a remote DeployStudio Assistant with no modification to Spirits config storage.
    ds_configuration_file = File.join(__dir__, 'config', 'server.yml')
    ds_configuration = YAML.load(File.read(ds_configuration_file))

    # Augment configuration with generated paths
    configure do
      set :repo_path, File.absolute_path(settings.repository_root)
      set :server, ds_configuration
      set :server_config_path, ds_configuration_file
    end

    raise 'You cannot start Spirit without a repository' unless File.exists?(settings.repo_path)

    unless File.exists?(File.join(settings.repo_path, 'Databases', 'ByHost', 'group.settings.plist'))
      logger.info 'Databases/ByHost/group.settings.plist does not exist in your repo... creating one'

      FileUtils.cp(
          File.absolute_path('templates/group.settings.plist'),
          File.join(settings.repo_path, 'Databases', 'ByHost', 'group.settings.plist')
      )
    end

    # TODO: Actual authentication implementation
    use Rack::Auth::Basic do |username, password|
      username == settings.username && password == settings.password
    end

    # DeployStudio supplies binary plists using 'text/xml' headers. It doesn't care about HTTP.
    before do # Set plist object on @request_payload if request content was text/xml
      if request.media_type == 'text/xml' && request.content_length.to_i > 0
        request.body.rewind

        begin
          post_plist = CFPropertyList::List.new :data => request.body.read

          @request_payload = CFPropertyList.native_types(post_plist.value)
        rescue CFFormatError => e
          logger.error 'The client sent an invalid request, it did not contain a property list.'
          logger.debug 'Request content follows'
          logger.debug request.body.read

          raise e
        end
      end

      content_type 'application/octet-stream'
    end

    Computer.path = File.join(settings.repo_path, 'Databases', 'ByHost')
    Computer.primary_key = settings.server['repository']['hostPrimaryKey']

    ComputerGroup.groups_plist = File.join(settings.repo_path, 'Databases', 'ByHost', 'group.settings.plist')

    Master.path = File.join(settings.repo_path, 'Masters')
    logger.info 'Scanning for new images and building keywords list...'
    Master.rebuild_keywords

    Package.path = File.join(settings.repo_path, 'Packages')
    CopyFile.path = File.join(settings.repo_path, 'Files')
    Script.path = File.join(settings.repo_path, 'Scripts')
    Log.path = File.join(settings.repo_path, 'Logs')
    Workflow.path = File.join(settings.repo_path, 'Databases', 'Workflows')
  end
end
