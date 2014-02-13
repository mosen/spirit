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

    it_behaves_like 'an xml plist post'
  end

  describe '/sets/get/all' do
    before do
      authorize "admin", "secret"
      get '/packages/sets/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist response'
  end

  describe '/sets/get/entry' do
    before do
      authorize "admin", "secret"
      get '/packages/sets/get/entry', { 'id' => 'MockPackageSet' }
    end

    it_behaves_like 'an xml plist response'
  end

  describe '/sets/ren/entry?id=&new_id=' do
    before do
      authorize "admin", "secret"
      post '/packages/sets/ren/entry', { 'id' => 'MockPackageSet', 'new_id' => 'MockRenamedPackageSet' }
    end

    it_behaves_like 'an xml plist post'
  end

  describe '/sets/add/entry?id=&pkg= (add package to set)' do
    before do
      authorize "admin", "secret"
      post '/packages/sets/add/entry', { 'id' => 'MockPackageSet', 'pkg' => 'Mock.pkg' }
    end

    it_behaves_like 'an xml plist post'
  end

  describe '/get/all' do
    before do
      authorize "admin", "secret"
      get '/packages/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist response'
  end

  describe '/get/entry' do
    before do
      authorize "admin", "secret"
      get '/packages/get/entry', { 'id' => 'MockPackageSet' }
    end

    let (:plist_hash) {
      plist = CFPropertyList::List.new(:data => last_response.body)
      CFPropertyList.native_types(plist.value)
    }

    it_behaves_like 'an xml plist response'

    it 'contains an items key' do
      expect(plist_hash[0]['items']).to be
    end
  end

end