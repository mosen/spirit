require 'spec_helper'
require 'shared_examples_http'
require 'shared_contexts'
require 'cfpropertylist'

COMPUTER_MOCK_PATH = File.expand_path(__FILE__ + '/../../../ds_repo/Databases/ByHost/W1111GTM4QQ.plist')
GROUP_SETTINGS_PATH = File.expand_path(__FILE__ + '/../../../ds_repo/Databases/ByHost/group.settings.plist')

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

      it 'sets the group property to the default group' do
        expect(plist_hash['W1111GTM4QQ']['dstudio-group']).to eq('Default')
      end

      it 'inherits the group prefix for the cn (computer name)' do
        expect(plist_hash['W1111GTM4QQ']['cn']).to start_with('mockgrp')
      end

      it 'creates a computer number in the series specified by the group setting' do

      end

      it 'inherits the setting `Disable computer after successful execution`' do
        expect(plist_hash['W1111GTM4QQ']['dstudio-auto-disable']).to eq('YES')
      end

      it 'inherits the setting `Reset default workflow after a successful execution`' do
        expect(plist_hash['W1111GTM4QQ']['dstudio-auto-reset-workflow']).to eq('YES')
      end

      it 'inherits the group prefix for the boot camp computer name' do
        expect(plist_hash['W1111GTM4QQ']['dstudio-bootcamp-windows-computer-name']).to start_with('MOCKGRP')
      end


      it 'inherits the os x server key setting' do

      end

      it 'inherits the xsan 1.x key setting' do

      end

      it 'inherits the boot camp serial number setting' do
        expect(plist_hash['W1111GTM4QQ']['dstudio-bootcamp-windows-product-key']).to eq('THISI-SAWIN-DOWSP-RODUC-TKEY0')
      end

      it 'inherits the array of client management computer groups' do
        expect(plist_hash['W1111GTM4QQ']['dstudio-clientmanagement-computer-groups']).to be_instance_of(Array)
        expect(plist_hash['W1111GTM4QQ']['dstudio-clientmanagement-computer-groups']).to include('mock-wgm-group')
      end

      it 'inherits the group custom properties' do
        expect(plist_hash['W1111GTM4QQ']['dstudio-custom-properties']).to be_instance_of(Array)
        expect(plist_hash['W1111GTM4QQ']['dstudio-custom-properties'][0]).to be_instance_of(Hash)
        expect(plist_hash['W1111GTM4QQ']['dstudio-custom-properties'][0]['dstudio-custom-property-key']).to eq('DSCP_1')
        expect(plist_hash['W1111GTM4QQ']['dstudio-custom-properties'][0]['dstudio-custom-property-label']).to eq('Custom Property 1')
        expect(plist_hash['W1111GTM4QQ']['dstudio-custom-properties'][0]['dstudio-custom-property-value']).to eq('value')
      end

      it 'inherits the setting `delete locations`' do
        expect(plist_hash['W1111GTM4QQ']['dstudio-host-delete-other-locations']).to eq('YES')
      end

      it 'inherits the default network interface setting' do
        expect(plist_hash['W1111GTM4QQ']['dstudio-host-first-interface']).to eq('en0')
      end

      it 'inherits the created network location' do

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

  # NOTE: Does not get called when removing a computer from DS. Unsure of when this will get called.
  describe '/del/entry' do

  end

  # Post concated computers
  describe '/import/entries' do

  end

end
