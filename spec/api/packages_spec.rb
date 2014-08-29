require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/packages' do


  describe '/get/all' do
    before do
      get '/packages/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'a binary plist response'
  end

  describe '/get/entry' do
    before do
      get '/packages/get/entry', { 'id' => 'MockPackageSet' }
    end

    let (:plist_hash) {
      plist = CFPropertyList::List.new(:data => last_response.body)
      CFPropertyList.native_types(plist.value)
    }

    it_behaves_like 'a binary plist response'

    it 'contains an items key' do
      expect(plist_hash[0]['items']).to be
    end
  end

  describe '/del/entry' do

  end

  describe '/set/entry' do

  end

end