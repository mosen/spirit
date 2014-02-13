require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/workflows' do
  before do
    header 'User-Agent', 'DeployStudio%20Admin/130904 CFNetwork/596.5 Darwin/12.5.0 (x86_64) (iMac10%2C1)'
  end

  describe '/get/all' do
    before do
      authorize "admin", "secret"
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
      authorize "admin", "secret"
      get '/workflows/get/entry', { 'id' => 'AAAAAAAA-BBBB-CCCC-DDDD-EEEEFFFFFFFF' }
    end

    it_behaves_like 'an xml plist response'
  end

  describe '/set/entry?id=' do
    before do
      authorize "admin", "secret"
      post '/workflows/set/entry', { 'id' => 'AAAAAAAA-BBBB-CCCC-DDDD-EEEEFFFFFFFF' } # TODO: workflow plist in post body
    end

    it_behaves_like 'an xml plist post'
  end

end