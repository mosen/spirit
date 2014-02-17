require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/packages/sets' do

  describe '/get/all' do
    before do
      get '/packages/sets/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist response'
  end

  describe '/get/entry' do
    before do
      get '/packages/sets/get/entry', { 'id' => 'MockPackageSet' }
    end

    it_behaves_like 'an xml plist response'
  end

  describe '/add/entry?id=&pkg= (add package to set)' do
    before do
      post '/packages/sets/add/entry', { 'id' => 'MockPackageSet', 'pkg' => 'Mock.pkg' }
    end

    it_behaves_like 'an xml plist post'
  end

  describe '/new/entry' do
    before do
      post '/packages/sets/new/entry'
    end

    it_behaves_like 'an xml plist post'
  end

  describe '/ren/entry?id=&new_id=' do
    before do
      post '/packages/sets/ren/entry', { 'id' => 'MockPackageSet', 'new_id' => 'MockRenamedPackageSet' }
    end

    it_behaves_like 'an xml plist post'
  end

end