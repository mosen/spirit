require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/workflows', use_fakefs: true do

  describe '/get/all' do
    before do
      get '/workflows/get/all', { 'id' => 'W1111GTM4QQ', 'groups' => '(null)' }
    end

    it_behaves_like 'a binary plist response'
  end

  # After 'At workflow selector status' is posted, this is called to retrieve available workflows (In netboot environment).
  describe '/get/all?id=SERIAL&groups=&client=runtime' do
    before do
      get '/workflows/get/all', { 'id' => 'W1111GTM4QQ', 'groups' => '', 'client' => 'runtime' }
    end
  end

  # Get the content of a workflow. Used by DS Admin and when a runtime begins to execute a workflow.
  describe '/get/entry?id=' do
    before do
      get '/workflows/get/entry', { 'id' => 'AAAAAAAA-BBBB-CCCC-DDDD-EEEEFFFFFFFF' }
    end

    it_behaves_like 'a binary plist response'
  end

  describe '/del/entry' do

  end

  describe '/dup/entry' do

  end

  describe '/set/entry?id=' do
    before do
      post '/workflows/set/entry', { 'id' => 'AAAAAAAA-BBBB-CCCC-DDDD-EEEEFFFFFFFF' } # TODO: workflow plist in post body
    end

    it_behaves_like 'a successful post'
  end

end