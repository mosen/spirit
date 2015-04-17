require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

PACKAGES_MOCK_PATH = File.expand_path(__FILE__ + '/../../../ds_repo/Packages')

describe '/packages/sets', use_fakefs: true do
  def mock_sets
    FileUtils.mkdir_p PACKAGES_MOCK_PATH
    Dir.mkdir(File.join(PACKAGES_MOCK_PATH, 'MockPackageSet'))
    Dir.mkdir(File.join(PACKAGES_MOCK_PATH, 'MockPackageSet', 'Mock.pkg'))
  end

  before(:each) do
    mock_sets
  end


  describe '/get/all' do
    before do
      get '/packages/sets/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'a binary plist response'
  end

  describe '/get/entry' do
    before do
      get '/packages/sets/get/entry', { 'id' => 'MockPackageSet' }
    end

    it_behaves_like 'a binary plist response'
  end

  describe '/add/entry?id=&pkg= (add package to set)' do
    before do
      post '/packages/sets/add/entry', { 'id' => 'MockPackageSet', 'pkg' => 'Mock.pkg' }
    end

    it_behaves_like 'a successful post'
  end

  describe '/new/entry' do
    before do
      post '/packages/sets/new/entry'
    end

    it_behaves_like 'a successful post'
  end

  describe '/ren/entry?id=&new_id=' do
    before do
      post '/packages/sets/ren/entry', { 'id' => 'MockPackageSet', 'new_id' => 'MockRenamedPackageSet' }
    end

    it_behaves_like 'a successful post'
  end

end