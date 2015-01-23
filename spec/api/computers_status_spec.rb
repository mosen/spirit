require 'spec_helper'
require 'shared_examples_http'
require 'shared_contexts'

STATUS_WAITING_PLIST = File.read(File.expand_path(__FILE__ + '/../../fixtures/computers/status/waiting.plist'))
STATUS_REPO_ERROR = File.read(File.expand_path(__FILE__ + '/../../fixtures/computers/status/repo_error.plist'))
WORKFLOW_PROGRESS_PLIST = File.read(File.expand_path(__FILE__ + '/../../fixtures/computers/status/workflow.plist'))
STATUS_SELECTOR_PLIST = File.read(File.expand_path(__FILE__ + '/../../fixtures/computers/status/workflow_selector.plist'))

describe '/computers/status' do
  before(:each) do
    HostStatus.delete_all
  end


  describe '/status/get/all' do
    let!(:host_status) { FactoryGirl.create :host_status }

    before do
      get '/computers/status/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'a binary plist response'

    context 'with the plist result' do
      include_context 'with parsed plist response'

      it 'contains a key with the id of the host' do
        expect(plist_hash).to have_key(host_status.identifier)
      end

      it 'contains a valid date of last update' do
        expect(plist_hash[host_status.identifier]).to have_key('date')
        expect(plist_hash[host_status.identifier]['date']).to be_a_kind_of(Time)
      end

      it 'contains the DSRemoteStatusHostInformation key' do
        expect(plist_hash[host_status.identifier]).to have_key('DSRemoteStatusHostInformation')
      end
    end
  end

  # Post a Repository access error status
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

  # Post status - Waiting at workflow selector
  describe '/status/set/entry?tag=DSRemoteStatusHostInformation' do
    before do
      post(
          '/computers/status/set/entry?id=W1111GTM4QQ&tag=DSRemoteStatusHostInformation',
          STATUS_SELECTOR_PLIST,
          { 'CONTENT_TYPE' => 'text/xml;charset=utf8' }
      )
    end
  #
  #   it 'creates a status entry for the mock status update' do
  #     # TODO: query for mock status
  #
  #   end
  #
  #   it 'sets the identifier to the value of the `id` parameter' do
  #     expect(HostStatus.where('identifier = ?', ['W1111GTM4QQ'])).to_not be_empty
  #   end
  end


  # The runtime client will post a zero length request, I assume to init workflow status information for this id
  describe '/status/set/entry?id=SERIAL&tag=DSRemoteStatusWorkflowsInformation (Content Length 0)' do
    pending
  end

  #
  describe '/status/set/entry?tag=DSRemoteStatusWorkflowsInformation' do
    pending
  #   before do
  #     post(
  #         '/computers/status/set/entry?id=W1111GTM4QQ&tag=DSRemoteStatusWorkflowsInformation',
  #         WORKFLOW_PROGRESS_PLIST,
  #         { 'CONTENT_TYPE' => 'text/xml;charset=utf8' }
  #     )
  #   end
  #
  #   it 'creates a workflow status entry for the mock status update' do
  #     # TODO: query for mock status
  #   end
  end

end