require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/workflows' do

  describe '/get/all' do
    before do
      get '/workflows/get/all', { 'id' => 'W1111GTM4QQ', 'groups' => '(null)' }
    end

    let (:plist_hash) {
      plist = CFPropertyList::List.new(:data => last_response.body)
      CFPropertyList.native_types(plist.value)
    }

    it_behaves_like 'an xml plist response'

  end

  describe '/get/entry?id=' do
    before do
      get '/workflows/get/entry', { 'id' => 'AAAAAAAA-BBBB-CCCC-DDDD-EEEEFFFFFFFF' }
    end

    it_behaves_like 'an xml plist response'
  end

  describe '/set/entry?id=' do
    before do
      post '/workflows/set/entry', { 'id' => 'AAAAAAAA-BBBB-CCCC-DDDD-EEEEFFFFFFFF' } # TODO: workflow plist in post body
    end

    it_behaves_like 'an xml plist post'
  end

end