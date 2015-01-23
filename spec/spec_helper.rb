RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
Dir[File.expand_path(File.dirname(__FILE__) + "/../app/helpers/**/*.rb")].each(&method(:require))
require 'factory_girl'
require 'fakefs/spec_helpers'
require 'rack/test'

FactoryGirl.find_definitions

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include FactoryGirl::Syntax::Methods
  conf.include FakeFS::SpecHelpers

  conf.expect_with :rspec do |c|
    c.syntax = :expect
  end

  conf.before(:all) do
    authorize 'admin', 'secret'
    header 'User-Agent', 'DeployStudio%20Admin/141021 CFNetwork/673.5 Darwin/13.4.0 (x86_64) (iMac10%2C1)'

    @group_settings_path = File.expand_path(__FILE__ + '/../ds_repo/Databases/ByHost/group.settings.plist')
  end

  # Set up repo fixture before each FakeFS spec
  conf.before(:each) do
    @group_settings_default = File.read 'spec/fixtures/computers/group.settings.plist'
  end

  conf.after(:each) do
  end

  conf.before(:suite) do
    FactoryGirl.lint
  end


end

def app(app = nil, &blk)
  @app ||= block_given? ? app.instance_eval(&blk) : app
  @app ||= Padrino.application
end
