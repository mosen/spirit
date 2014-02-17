require 'spec_helper'
require 'shared_examples_http'
require 'shared_contexts'
require 'cfpropertylist'

GROUP_SETTINGS_PATH = File.expand_path(__FILE__ + '/../../../ds_repo/Databases/ByHost/group.settings.plist')

describe '/computers/groups', fakefs: true do
  def stub_groups


    FileUtils.mkdir_p File.dirname(GROUP_SETTINGS_PATH)
    File.open File.expand_path(GROUP_SETTINGS_PATH), 'w' do |f|
      f.write(@group_settings_default)
    end
  end

  describe '/get/all' do
    before do
      stub_groups

      get '/computers/groups/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist response'

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

    it_behaves_like 'an xml plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains a key `default`' do
        expect(plist_hash).to have_key('default')
      end
    end
  end

  describe '/get/entry?id=' do
    before do
      stub_groups
      get '/computers/groups/get/entry', { 'id' => 'MockGroup' }
    end

    it_behaves_like 'an xml plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains a key with the group name' do
        expect(plist_hash).to have_key('MockGroup')
      end
    end
  end

  # The `default` checkbox is unticked
  describe '/del/default' do
    before do
      stub_groups
      post '/computers/groups/del/default', { 'id' => 'MockGroup' }
    end

    it_behaves_like 'an xml plist post'

    it 'removes the default option from `MockGroup`' do

    end
  end

  # Remove a computer group
  describe '/del/entry' do
    before do
      stub_groups
      post '/computers/groups/del/entry', { 'id' => 'MockGroup' }
    end

    it_behaves_like 'an xml plist post'

    it 'deletes the entry from the group settings plist' do
      plist = CFPropertyList::List.new(:file => GROUP_SETTINGS_PATH)
      groups = CFPropertyList.native_types(plist.value)

      expect(groups).to_not have_key('MockGroup')
    end
  end

  # Plus button is clicked, so a group named `Group N` is created where N = N+1
  describe '/new/entry' do
    before do
      stub_groups
      post '/computers/groups/new/entry'
    end

    it_behaves_like 'an xml plist post'

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
      stub_groups
      post '/computers/groups/ren/entry', { 'id' => 'MockGroup', 'new_id' => 'MockGroupRenamed' }
    end

    it_behaves_like 'an xml plist post'

    it 'renames the `MockGroup` entry to `MockGroupRenamed` in the group settings' do
      plist = CFPropertyList::List.new(:file => GROUP_SETTINGS_PATH)
      groups = CFPropertyList.native_types(plist.value)

      expect(groups).to have_key('MockGroupRenamed')
      expect(groups).to_not have_key('MockGroup')
    end
  end

  # The `default` checkbox is ticked
  describe '/set/default' do
    before do
      post '/computers/groups/set/default', { 'id' => 'MockGroup' }
    end

    it_behaves_like 'an xml plist post'

    it 'sets the default group to `MockGroup`' do

    end

  end

  # Update group detail
  describe '/set/entry' do
    before do
      stub_groups
      post '/computers/groups/set/entry?id=MockGroup', '<key>test</key><string>testValue</string>'
    end

    it_behaves_like 'an xml plist post'

    it 'sets the contents of the key `MockGroup` in the group settings to the posted plist' do
      # TODO
    end

  end

end