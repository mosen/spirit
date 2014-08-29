require 'spec_helper'
require 'shared_examples_http'
require 'shared_contexts'
require_relative '../../models/host_status'

STATUS_WAITING_PLIST = File.read(File.expand_path(__FILE__ + '/../../fixtures/computers/status/waiting.plist'))
STATUS_REPO_ERROR = File.read(File.expand_path(__FILE__ + '/../../fixtures/computers/status/repo_error.plist'))
WORKFLOW_PROGRESS_PLIST = File.read(File.expand_path(__FILE__ + '/../../fixtures/computers/status/workflow.plist'))

describe '/computers/status' do
  after(:each) do
    HostStatus.delete_all
  end

  describe '/status/get/all' do
    before do
      get '/computers/status/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'a binary plist response'

    context 'with the plist result' do

    end
  end

  describe '/status/set/entry?tag=DSRemoteStatusHostInformation (status without host info)' do
    before do
      post(
          '/computers/status/set/entry?id=W1111GTM4QQ&tag=DSRemoteStatusHostInformation',
          STATUS_REPO_ERROR,
          { 'CONTENT_TYPE' => 'text/xml;charset=utf8' }
      )
    end

    it 'creates a row with identifier from the `id` parameter' do
      expect(HostStatus.where('identifier = ?', ['W1111GTM4QQ'])).to_not be_empty
    end

  end

  describe '/status/set/entry?tag=DSRemoteStatusHostInformation (posting twice with the same serial number)' do
    before do
      2.times do
        post(
            '/computers/status/set/entry?id=W1111GTM4QQ&tag=DSRemoteStatusHostInformation',
            STATUS_REPO_ERROR,
            { 'CONTENT_TYPE' => 'text/xml;charset=utf8' }
        )
      end
    end

    it 'does not create a duplicate row' do
      expect(HostStatus.count).to eq(1)
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

    it 'sets the identifier to the value of the `id` parameter' do
      expect(HostStatus.where('identifier = ?', ['W1111GTM4QQ'])).to_not be_empty
    end
  end

  describe '/status/set/entry?tag=DSRemoteStatusWorkflowsInformation' do
    before do
      post(
          '/computers/status/set/entry?id=W1111GTM4QQ&tag=DSRemoteStatusWorkflowsInformation',
          WORKFLOW_PROGRESS_PLIST,
          { 'CONTENT_TYPE' => 'text/xml;charset=utf8' }
      )
    end

    it 'creates a workflow status entry for the mock status update' do
      # TODO: query for mock status
    end
  end

end