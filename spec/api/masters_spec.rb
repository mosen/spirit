require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/masters' do

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