require 'spec_helper'
require 'shared_examples_http'
require 'shared_contexts'

STATUS_WAITING_PLIST = File.read(File.expand_path(__FILE__ + '/../../fixtures/computers/status/waiting.plist'))

describe '/computers/status' do

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
      post(
          '/computers/status/set/entry?id=W1111GTM4QQ&tag=DSRemoteStatusHostInformation',
          STATUS_WAITING_PLIST,
          { 'CONTENT_TYPE' => 'text/xml;charset=utf8' }
      )
    end

    it 'creates a status entry for the mock status update' do
      # TODO: query for mock status
    end
  end

  describe '/status/set/entry?tag=DSRemoteStatusWorkflowsInformation' do
    before do
      post '/computers/status/set/entry', { 'id' => 'W1111GTM4QQ', 'tag' => 'DSRemoteStatusWorkflowsInformation' }
    end

    it 'creates a workflow status entry for the mock status update' do
      # TODO: query for mock status
    end
  end

end