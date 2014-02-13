require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/packages' do
  before do
    header 'User-Agent', 'DeployStudio%20Admin/130904 CFNetwork/596.5 Darwin/12.5.0 (x86_64) (iMac10%2C1)'
  end

  describe '/sets/new/entry' do
    before do
      authorize "admin", "secret"
      post '/packages/sets/new/entry'
    end


  end

end