require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/user' do
  before do
    header 'User-Agent', 'DeployStudio%20Admin/130904 CFNetwork/596.5 Darwin/12.5.0 (x86_64) (iMac10%2C1)'
  end

  describe '/get/credentials' do
    before do
      get '/user/get/credentials', { 'uid' => 'admin' }
    end

    let (:plist_hash) {
      plist = CFPropertyList::List.new(:data => last_response.body)
      CFPropertyList.native_types(plist.value)
    }

    it_behaves_like 'an xml plist response'

    it 'contains a credentials array' do
      expect(plist_hash['credentials']).to be_instance_of(Array)
    end

    it 'contains a date key' do
      expect(plist_hash['date']).to be
    end
  end

end