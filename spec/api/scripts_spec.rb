require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/scripts' do
  before do
    header 'User-Agent', 'DeployStudio%20Admin/130904 CFNetwork/596.5 Darwin/12.5.0 (x86_64) (iMac10%2C1)'
  end

  describe '/get/all' do
    before do
      authorize "admin", "secret"
      get '/scripts/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    let (:plist_hash) {
      plist = CFPropertyList::List.new(:data => last_response.body)
      CFPropertyList.native_types(plist.value)
    }

    it_behaves_like 'an xml plist response'

    it 'contains a scripts array' do
      expect(plist_hash['scripts']).to be_instance_of(Array)
    end
  end

end