require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

MASTERS_MOCK_PATH = File.expand_path(__FILE__ + '/../../../ds_repo/Masters')

describe '/masters', use_fakefs: true do
  def mock_masters

  end

  before(:each) do
    mock_masters
  end

  describe '/get/all' do

  end

  describe '/get/all?keywords=HFS' do
    before do
      get '/masters/get/all', { 'keywords' => 'HFS' }
    end

    it_behaves_like 'a binary plist response'
  end

  describe '/get/entry' do

  end

  describe '/compress/entry' do

  end

  describe '/del/entry' do

  end

  describe '/ren/entry' do

  end

  describe '/scan/entry' do

  end

  describe '/set/entry' do

  end

  describe '/workinprogress/finalize' do

  end
end