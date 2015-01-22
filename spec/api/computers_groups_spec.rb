require 'spec_helper'
require 'shared_examples_http'
require 'shared_contexts'
require 'cfpropertylist'

GROUP_SETTINGS_PATH = File.expand_path(__FILE__ + '/../../../ds_repo/Databases/ByHost/group.settings.plist')

describe '/computers/groups', use_fakefs: true do

  def stub_groups
    FileUtils.mkdir_p File.dirname(GROUP_SETTINGS_PATH)
    File.open File.expand_path(GROUP_SETTINGS_PATH), 'w' do |f|
      f.write(@group_settings_default)
    end
  end

  let(:group_template) {
    {
        'cn' => 'nameprefix',
        'dstudio-serial-number' => '',
        'dstudio-host-new-network-location' => 'NO',
        'dstudio-hostname' => 'hostnameprefix',
        'dstudio-auto-reset-workflow' => 'NO',
        'dstudio-auto-disable' => 'NO',
        'dstudio-disabled' => 'NO',
        'dstudio-host-delete-other-locations' => 'NO',
        'dstudio-group-name' => 'Mock Group',
        'dstudio-bootcamp-windows-product-key' => '',
        'dstudio-bootcamp-windows-computer-name' => '',
        'dstudio-host-interfaces' => {
            'en0' => {
                'dstudio-host-airport-name' => '',
                'dstudio-router-ip' => '',
                'dstudio-host-auto-discovery-proxy' => 'NO',
                'dstudio-search-domains' => '',
                'dstudio-host-http-proxy-server' => '',
                'dstudio-host-airport' => 'NO',
                'dstudio-host-interfaces' => 'en0',
                'dstudio-host-ftp-proxy-port' => '',
                'dstudio-host-auto-config-proxy' => 'NO',
                'dstudio-host-https-proxy' => 'NO',
                'dstudio-host-ftp-proxy-server' => '',
                'dstudio-host-ip' => '',
                'dstudio-host-https-proxy-port' => '',
                'dstudio-host-airport-password' => '',
                'dstudio-dns-ips' => '',
                'dstudio-host-https-proxy-server' => '',
                'dstudio-host-http-proxy-port' => '',
                'dstudio-subnet-mask' => '',
                'dstudio-host-ftp-proxy' => 'NO',
                'dstudio-host-http-proxy' => 'NO',
                'dstudio-host-auto-config-proxy-url' => ''
            }
        },
        'dstudio-xsan-license' => '',
        'dstudio-group-hosname-index-first-value' => 1,
        'dstudio-host-location' => '',
        'dstudio-group-hosname-index-length' => 1
    }
  }

  before(:each) do
    stub_groups
  end

  describe '/get/all' do
    before do
      get '/computers/groups/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'a binary plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains a key `groups`' do
        expect(plist_hash).to have_key('groups')
      end

      it 'contains member `groups` which is an array' do
        expect(plist_hash['groups']).to be_instance_of(Array)
      end
    end
  end

  describe '/get/default' do
    before do
      get '/computers/groups/get/default', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'a binary plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains a key `default`' do
        expect(plist_hash).to have_key('default')
      end
    end
  end

  describe '/get/entry?id=' do
    before do
      get '/computers/groups/get/entry', { 'id' => 'Group 1' }
    end

    it_behaves_like 'a binary plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains a key with the group name' do
        expect(plist_hash).to have_key('Group 1')
      end
    end
  end

  # The `default` checkbox is unticked
  describe '/del/default' do
    before do
      post '/computers/groups/del/default', { 'id' => 'Group 1' }
    end

    it_behaves_like 'a successful post'

    it 'removes the default group key `_dss_default`' do
      plist = CFPropertyList::List.new(:file => GROUP_SETTINGS_PATH)
      groups = CFPropertyList.native_types(plist.value)

      expect(groups).to_not have_key('_dss_default')
    end
  end


  # Remove a computer group
  describe '/del/entry' do
    before do
      post '/computers/groups/del/entry', { 'id' => 'MockGroup' }
    end

    it_behaves_like 'a successful post'

    it 'deletes the entry from the group settings plist' do
      plist = CFPropertyList::List.new(:file => GROUP_SETTINGS_PATH)
      groups = CFPropertyList.native_types(plist.value)

      expect(groups).to_not have_key('MockGroup')
    end
  end

  # Plus button is clicked, so a group named `Group N` is created where N = N+1
  describe '/new/entry' do
    before do
      post '/computers/groups/new/entry'
    end

    it_behaves_like 'a successful post'

    it 'creates an entry called `Group 1` for the first group' do
      plist = CFPropertyList::List.new(:file => GROUP_SETTINGS_PATH)
      groups = CFPropertyList.native_types(plist.value)

      expect(groups).to have_key('Group 1')
    end

    it 'creates a value for `dstudio-group-name` in the `Group 1` group' do
      plist = CFPropertyList::List.new(:file => GROUP_SETTINGS_PATH)
      groups = CFPropertyList.native_types(plist.value)

      expect(groups['Group 1']).to have_key('dstudio-group-name')
      expect(groups['Group 1']['dstudio-group-name']).to eq('Group 1')
    end
  end

  # Double-click and rename group
  describe '/ren/entry' do
    before do
      post '/computers/groups/ren/entry', { 'id' => 'Group 1', 'new_id' => 'MockGroupRenamed' }
    end

    it_behaves_like 'a successful post'

    it 'renames the `Group 1` entry to `MockGroupRenamed` in the group settings' do
      plist = CFPropertyList::List.new(:file => GROUP_SETTINGS_PATH)
      groups = CFPropertyList.native_types(plist.value)

      expect(groups).to have_key('MockGroupRenamed')
      expect(groups).to_not have_key('Group 1')
    end
  end

  # The `default` checkbox is ticked
  describe '/set/default' do
    before do
      post '/computers/groups/set/default', { 'id' => 'Group 1' }
    end

    it_behaves_like 'a successful post'

    it 'sets the default group value to `Group 1`' do
      plist = CFPropertyList::List.new(:file => GROUP_SETTINGS_PATH)
      groups = CFPropertyList.native_types(plist.value)

      expect(groups).to have_key('_dss_default')
      expect(groups['_dss_default']).to have_key('dstudio-group-default-group-name')
      expect(groups['_dss_default']['dstudio-group-default-group-name']).to eq('Group 1')
    end

  end

  # Update group detail
  describe '/set/entry' do
    before do
      group_content_plist = group_template.to_plist
      post '/computers/groups/set/entry?id=MockGroup', group_content_plist, { 'CONTENT_TYPE' => 'text/xml' }
    end

    it_behaves_like 'a successful post'

    it 'sets the contents of the key `MockGroup` in the group settings to the posted plist' do
      plist = CFPropertyList::List.new(:file => GROUP_SETTINGS_PATH)
      groups = CFPropertyList.native_types(plist.value)

      expect(groups).to have_key('MockGroup')
      expect(groups['MockGroup']).to have_key('dstudio-group-name')
      expect(groups['MockGroup']['dstudio-group-name']).to eq('Mock Group')
    end

  end

end