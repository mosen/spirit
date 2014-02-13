require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/server' do
  before do
    header 'User-Agent', 'DeployStudio%20Admin/130904 CFNetwork/596.5 Darwin/12.5.0 (x86_64) (iMac10%2C1)'
  end

  describe '/get/stats' do
    before do
      authorize "admin", "secret"
      get '/server/get/stats', { 'id' => 'W1111GTM4QQ' }
    end

    let (:plist_hash) {
      plist = CFPropertyList::List.new(:data => last_response.body)
      CFPropertyList.native_types(plist.value)
    }

    it_behaves_like 'an xml plist response'

    it 'contains a client counter' do
      expect(plist_hash['clients']).to be
    end

    it 'contains a computers counter' do
      expect(plist_hash['computers']).to be
    end

    it 'contains a masters counter' do
      expect(plist_hash['masters']).to be
    end

    it 'contains a packages counter' do
      expect(plist_hash['packages']).to be
    end

    it 'contains a scripts counter' do
      expect(plist_hash['scripts']).to be
    end

    it 'contains a workflows counter' do
      expect(plist_hash['workflows']).to be
    end
  end

end