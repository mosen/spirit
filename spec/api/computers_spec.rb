require 'spec_helper'
require 'shared_examples_http'
require 'shared_contexts'

describe '/computers' do

  describe '/get/all' do
    before do
      get '/computers/get/all'
    end

    it_behaves_like 'an xml plist response'

    context 'with the plist result' do
      include_context 'with parsed plist response'

      it 'contains a key `computers`' do
        expect(plist_hash).to have_key('computers')
      end

      it 'contains a key `groups`' do
        expect(plist_hash).to have_key('groups')
      end

      it 'contains a non empty value for the default group' do
        expect(plist_hash['groups']).to have_key('_dss_default')
        expect(plist_hash['groups']['_dss_default']).to have_key('dstudio-group-default-group-name')
        expect(plist_hash['groups']['_dss_default']).to_not be_empty
      end
    end
  end

  # Create a new computers entry
  describe '/get/entry?populate=yes' do
    before do
      get '/computers/get/entry', { 'sn' => 'W1111GTM4QQ', 'mac' => '00:11:C0:FF:EE', 'populate' => 'yes' }
    end

    it_behaves_like 'an xml plist response'

    context 'with the plist result' do
      include_context 'with parsed plist response'

      it 'contains one key equal to the serial number' do
        expect(plist_hash.keys.length).to eq(1)
        expect(plist_hash.keys).to include('W1111GTM4QQ')
      end

      it 'creates a plist named after the serial number in the repository' do
        expect(File.exists? File.join('ds_repo', 'Databases', 'ByHost', 'W1111GTM4QQ.plist')).to be_true
      end

      it 'inherits settings from the default group' do
        # TODO: Resultant plist should contain inherited settings of the default group
      end
    end
  end

  # Get a single entry with key (id) given primary key (pk)
  describe '/get/entry?id=&pk=sn' do
    before do
      get '/computers/get/entry', { 'id' => 'W1111GTM4QQ', 'pk' => 'sn' }
    end

    # TODO: test ethernet ID as primary key

    it_behaves_like 'an xml plist response'
  end

  describe '/groups/get/all' do
    before do
      get '/computers/groups/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist response'

    context 'with the plist result' do
      include_context 'with parsed plist response'

      it 'contains a key `groups`' do
        expect(plist_hash).to have_key('groups')
      end

    end
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
      mock_computer_plist = File.join('spec', 'fixtures', 'computers', 'Q03G55FVDRJL.plist')
      post '/computers/set/entry?id=Q03G55FVDRJL&pk=sn', File.read(mock_computer_plist), { 'Content-Type' => 'text/xml;charset=utf8' }
    end

    it_behaves_like 'an xml plist post'

    # TODO: verify that respository plist is identical to set plist
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
      post '/computers/status/set/entry?id=W1111GTM4QQ&tag=DSRemoteStatusHostInformation', { 'id' => 'W1111GTM4QQ', 'tag' => 'DSRemoteStatusHostInformation' }
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
