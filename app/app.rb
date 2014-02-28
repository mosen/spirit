require 'yaml'
require 'cfpropertylist'
require 'sinatra/config_file'

module Spirit
  class App < Padrino::Application
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

    ds_configuration_file = File.join(__dir__, 'config', 'server.yml')
    ds_configuration = YAML.load(File.read(ds_configuration_file))

    # Augment configuration with generated paths
    configure do
      set :repo_path, File.absolute_path(settings.repository_root)
      set :server, ds_configuration
      set :server_config_path, ds_configuration_file
    end

    if !File.exists?(settings.repo_path)
      raise "You cannot start Spirit without a repository"
    end

    if !File.exists? (File.join(settings.repo_path, 'Databases', 'ByHost', 'group.settings.plist'))
      logger.info "Databases/ByHost/group.settings.plist does not exist in your repo... creating one"

      FileUtils.cp(
          File.absolute_path('templates/group.settings.plist'),
          File.join(settings.repo_path, 'Databases', 'ByHost', 'group.settings.plist')
      )
    end

    # TODO: Actual authentication implementation
    use Rack::Auth::Basic do |username, password|
      username == settings.username && password == settings.password
    end

    # TODO: middleware that checks Content-Type text/xml and attempts to parse request like this
    before do # Set plist object on @request_payload if request content was text/xml
      if request.media_type == 'text/xml' && request.content_length
        request.body.rewind

        begin
          post_plist = CFPropertyList::List.new({
              format: CFPropertyList::List::FORMAT_XML,
              data: request.body.read
          })

          @request_payload = CFPropertyList.native_types(post_plist.value)
        rescue
          logger.warn 'Request could not be parsed as a Property List!'
        end
      end

      content_type 'text/xml;charset=utf8'
    end

    require_relative '../lib/spirit/master'
    require_relative '../lib/spirit/package'
    require_relative '../lib/spirit/script'
    require_relative '../lib/spirit/log'
    require_relative '../lib/spirit/workflow'
    require_relative '../lib/spirit/copy_file'
    require_relative '../lib/spirit/computer'
    require_relative '../lib/spirit/computer_group'

    Computer.path = File.join(settings.repo_path, 'Databases', 'ByHost')
    Computer.primary_key = settings.server['repository']['hostPrimaryKey']

    ComputerGroup.groups_plist = File.join(settings.repo_path, 'Databases', 'ByHost', 'group.settings.plist')

    Master.path = File.join(settings.repo_path, 'Masters')
    Package.path = File.join(settings.repo_path, 'Packages')
    CopyFile.path = File.join(settings.repo_path, 'Files')
    Script.path = File.join(settings.repo_path, 'Scripts')
    Log.path = File.join(settings.repo_path, 'Logs')
    Workflow.path = File.join(settings.repo_path, 'Databases', 'Workflows')
  end
end
