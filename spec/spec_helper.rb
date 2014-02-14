PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
require 'rack/test'
require 'factory_girl'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include FactoryGirl::Syntax::Methods
  conf.expect_with :rspec do |c|
    c.syntax = :expect
  end

  conf.before(:all) do
    authorize 'admin', 'secret'
    header 'User-Agent', 'DeployStudio%20Admin/130904 CFNetwork/596.5 Darwin/12.5.0 (x86_64) (iMac10%2C1)'
  end
end

# You can use this method to custom specify a Rack app
# you want rack-test to invoke:
#
#   app DemoProject::App
#   app DemoProject::App.tap { |a| }
#   app(DemoProject::App) do
#     set :foo, :bar
#   end
#
def app(app = nil, &blk)
  @app ||= block_given? ? app.instance_eval(&blk) : app
  @app ||= Padrino.application
end
