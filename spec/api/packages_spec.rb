require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/packages', use_fakefs: true do


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

  describe '/get/all listing non-flat bundles' do

    before do
      packages = File.expand_path(File.dirname(__FILE__) + "/../../ds_repo/Packages")
      FileUtils.mkdir_p(File.join(packages, "Bundle.pkg"))
      FileUtils.mkdir_p(File.join(packages, "Bundle.pkg", "Contents"))

      get '/packages/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    let (:plist_hash) {
      plist = CFPropertyList::List.new(:data => last_response.body)
      CFPropertyList.native_types(plist.value)
    }

    it 'contains the mock package bundle' do
      expect(plist_hash).to have_key('Bundle.pkg')
    end

    it 'does not list any sub items for the mock bundle' do
      expect(plist_hash['Bundle.pkg']['items']).to be < 1
    end
  end

end