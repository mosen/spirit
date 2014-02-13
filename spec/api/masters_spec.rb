require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/masters' do
  before do
    header 'User-Agent', 'DeployStudio%20Admin/130904 CFNetwork/596.5 Darwin/12.5.0 (x86_64) (iMac10%2C1)'
  end

  describe '/get/all?keywords=HFS' do
    before do
      authorize "admin", "secret"
      get '/masters/get/all', { 'keywords' => 'HFS' }
    end

    it_behaves_like 'an xml plist response'
  end
end