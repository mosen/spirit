require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/logs' do
  before do
    header 'User-Agent', 'DeployStudio%20Admin/130904 CFNetwork/596.5 Darwin/12.5.0 (x86_64) (iMac10%2C1)'
  end

  describe '/set/entry' do
    before do
      authorize "admin", "secret"
      post '/logs/set/entry', { 'id' => 'W1111GTM4QQ' } # TODO: post body
    end
  end

  describe '/rotate/entry' do
    before do
      authorize "admin", "secret"
      post '/logs/rotate/entry', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist post'
  end

end