require 'CFPropertyList'
require "sinatra/config_file"

module Spirit
  class App < Padrino::Application
    register Padrino::Rendering
    register Padrino::Mailer
    register Padrino::Helpers
    register Sinatra::ConfigFile

    # TODO: Actual authentication implementation
    use Rack::Auth::Basic do |username, password|
      username == 'admin' && password == 'secret'
    end

    # Requests may come from anywhere
    set :protection, false
    set :protect_from_csrf, false
    set :allow_disabled_csrf, false

    config_file 'config/spirit.yml'

    # Augment configuration with generated paths
    configure do
      set :repo_path, File.absolute_path(settings.repository_root)
    end

    # TODO: middleware that checks Content-Type text/xml and attempts to parse request like this
    before do # Set plist object on @request_payload if request content was text/xml
      if request.media_type == 'text/xml' && request.content_length
        request.body.rewind
        post_plist = CFPropertyList::List.new({
            format: CFPropertyList::List::FORMAT_XML,
            data: request.body.read
        })

        @request_payload = CFPropertyList.native_types(post_plist.value)
      end
    end

    require_relative '../lib/spirit/master'
    require_relative '../lib/spirit/package'
    require_relative '../lib/spirit/script'
    require_relative '../lib/spirit/log'
    require_relative '../lib/spirit/workflow'
    require_relative '../lib/spirit/copy_file'
    require_relative '../lib/spirit/computer'

    Computer.path = File.join(settings.repo_path, 'Databases', 'ByHost')
    Computer.primary_key = settings.server['repository']['hostPrimaryKey']

    Master.path = File.join(settings.repo_path, 'Masters')
    Package.path = File.join(settings.repo_path, 'Packages')
    CopyFile.path = File.join(settings.repo_path, 'Files')
    Script.path = File.join(settings.repo_path, 'Scripts')
    Log.path = File.join(settings.repo_path, 'Logs')
    Workflow.path = File.join(settings.repo_path, 'Databases', 'Workflows')
  end
end
