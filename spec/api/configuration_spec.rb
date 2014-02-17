require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/configuration' do

  describe '/get' do

  end

  describe '/get/repository' do
    before do
      get '/configuration/get/repository', { 'client_ip' => '127.0.0.1' }
    end

    let (:plist_hash) {
      plist = CFPropertyList::List.new(:data => last_response.body)
      CFPropertyList.native_types(plist.value)
    }

    it_behaves_like 'an xml plist response'

  end

  describe '/set' do

  end

end