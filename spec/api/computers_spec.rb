require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/computers' do

  describe '/get/all' do
    before do
      get '/computers/get/all'
    end

    it_behaves_like 'an xml plist response'

    context 'with the plist result' do
      it 'contains a key `computers`' do

      end

      it 'contains a key `groups`' do

      end

      it 'contains a non empty value for the default group' do

      end
    end
  end

  # Create a new computers entry
  describe '/get/entry?populate=yes' do
    before do
      get '/computers/get/entry', { 'sn' => 'W1111GTM4QQ', 'mac' => '00:11:C0:FF:EE', 'populate' => 'yes' }
    end

    it_behaves_like 'an xml plist post'

  end

  describe '/get/entry?id=&pk=sn' do
    before do
      get '/computers/get/entry', { 'id' => 'W1111GTM4QQ', 'pk' => 'sn' }
    end

    it_behaves_like 'an xml plist response'
  end

  describe '/groups/get/all' do
    before do
      get '/computers/groups/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist response'
  end

  describe '/groups/get/default' do
    before do
      get '/computers/groups/get/default', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist response'
  end

  describe '/groups/get/entry?id=' do
    before do
      get '/computers/groups/get/entry', { 'id' => 'MockGroup' }
    end

    it_behaves_like 'an xml plist response'
  end

  # Set computer information from runtime
  describe '/set/entry?id=' do
    before do
      post '/computers/set/entry', { 'id' => 'W1111GTM4QQ', 'pk' => 'sn' } # TODO: post body
    end
  end

  describe '/status/get/all' do
    before do
      get '/computers/status/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist response'

    context 'with the plist result' do

    end
  end

  describe '/status/set/entry?tag=DSRemoteStatusHostInformation' do
    before do
      authorize 'admin', 'secret'
      post '/computers/status/set/entry', { 'id' => 'W1111GTM4QQ', 'tag' => 'DSRemoteStatusHostInformation' }
    end

    it 'creates a status entry for the mock status update' do
      # TODO: query for mock status
    end
  end

  describe '/status/set/entry?tag=DSRemoteStatusWorkflowsInformation' do
    before do
      authorize 'admin', 'secret'
      post '/computers/status/set/entry', { 'id' => 'W1111GTM4QQ', 'tag' => 'DSRemoteStatusWorkflowsInformation' }
    end

    it 'creates a workflow status entry for the mock status update' do
      # TODO: query for mock status
    end
  end

end
