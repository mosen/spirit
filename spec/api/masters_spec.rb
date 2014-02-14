require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/masters' do

  describe '/get/all?keywords=HFS' do
    before do
      get '/masters/get/all', { 'keywords' => 'HFS' }
    end

    it_behaves_like 'an xml plist response'
  end
end