require 'spec_helper'
require 'shared_examples_http'
require 'shared_contexts'
require 'cfpropertylist'

COMPUTER_MOCK_PATH = File.expand_path(__FILE__ + '/../../../ds_repo/Databases/ByHost/W1111GTM4QQ.plist')

describe '/computers', fakefs: true do
  def stub_groups
    FileUtils.mkdir_p File.dirname(GROUP_SETTINGS_PATH)
    File.open File.expand_path(GROUP_SETTINGS_PATH), 'w' do |f|
      f.write(@group_settings_default)
    end
  end

  def stub_computers
    FileUtils.mkdir_p File.dirname(COMPUTER_MOCK_PATH)
    File.open File.expand_path(COMPUTER_MOCK_PATH), 'w' do |f|
      computer = {
        'architecture' => 'i386',
        'cn' => 'spirit1',
        'dstudio-auto-disable' => 'NO',
        'dstudio-auto-reset-workflow' => 'NO',
        'dstudio-bootcamp-windows-computer-name' => 'spirit1',
        'dstudio-disabled' => 'NO',
        'dstudio-editing-context' => [
            'dstudio-disabled',
            'dstudio-auto-started-workflow',
            'dstudio-auto-started-workflow-script'
        ],
        'dstudio-group' => 'Default',
        'dstudio-host-model-identified' => 'MacBookPro8,2',
        'dstudio-host-new-network-location' => 'NO',
        'dstudio-host-serial-number' => 'W1111GTM4QQ',
        'dstudio-host-type' => 'Mac',
        'dstudio-hostname' => 'spirit1',
        'dstudio-last-workflow' => '',
        'dstudio-last-workflow-duration' => '',
        'dstudio-last-workflow-status' => '',
        'dstudio-mac-addr' => '00:11:22:C0:FF:EE',
        'dstudio-users' => []
      }

      f.write(computer.to_plist)
    end
  end

  before(:each) do
    stub_computers
    stub_groups
  end

  # Get an index of computers
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
        expect(File.exists?(COMPUTER_MOCK_PATH)).to be_true
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


  # Set computer information from runtime
  describe '/set/entry?id=' do
    before do
      mock_computer_plist = File.join('spec', 'fixtures', 'computers', 'Q03G55FVDRJL.plist')
      post '/computers/set/entry?id=Q03G55FVDRJL&pk=sn', File.read(mock_computer_plist), { 'Content-Type' => 'text/xml;charset=utf8' }
    end

    it_behaves_like 'an xml plist post'

    # TODO: verify that respository plist is identical to set plist
  end

  describe '/del/entries' do
    before do
      delete_entries_plist = { 'ids' => [ 'W1111GTM4QQ' ] }.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
      post '/computers/del/entries', delete_entries_plist, { 'Content-Type' => 'text/xml;charset=utf8' }
    end

    it_behaves_like 'an xml plist post'

    it 'deletes the plist file relating to the specified id' do
      expect(File.exists?('W1111GTM4QQ.plist')).to be_false
    end
  end

  describe '/del/entry' do

  end

  describe '/import/entries' do

  end

end
