require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/computers' do
  before do
    header 'User-Agent', 'DeployStudio%20Admin/130904 CFNetwork/596.5 Darwin/12.5.0 (x86_64) (iMac10%2C1)'
  end

  describe '/get/all' do
    before do
      authorize "admin", "secret"
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
      authorize 'admin', 'secret'
      get '/computers/get/entry', { 'sn' => 'W1111GTM4QQ', 'mac' => '00:11:C0:FF:EE', 'populate' => 'yes' }
    end

    it_behaves_like 'an xml plist post'

  end

  describe '/status/get/all' do
    before do
      authorize 'admin', 'secret'
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
