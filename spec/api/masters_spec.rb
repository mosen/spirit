require 'spec_helper'
require 'shared_examples_http'
require 'shared_contexts'
require 'cfpropertylist'

MASTERS_MOCK_PATH = File.expand_path(__FILE__ + '/../../../ds_repo/Masters')

describe '/masters', use_fakefs: true do
  def mock_masters
    FileUtils.mkdir_p MASTERS_MOCK_PATH
    Dir.mkdir(File.join(MASTERS_MOCK_PATH, 'DEV'))
    Dir.mkdir(File.join(MASTERS_MOCK_PATH, 'FAT'))
    Dir.mkdir(File.join(MASTERS_MOCK_PATH, 'HFS'))
    Dir.mkdir(File.join(MASTERS_MOCK_PATH, 'NTFS'))
    Dir.mkdir(File.join(MASTERS_MOCK_PATH, 'PC'))
    Dir.mkdir(File.join(MASTERS_MOCK_PATH, 'tmp'))

    File.open(File.join(MASTERS_MOCK_PATH, 'HFS', 'mock.hfs.dmg'), 'w') do |f|
      f.write 'Mock HFS DMG'
    end

    File.open(File.join(MASTERS_MOCK_PATH, 'HFS', 'wrongextension.dmg'), 'w') do |f|
      f.write 'Mock Incorrectly Named DMG'
    end


    # Mock Windows 7 image, Only the .ntfs. image shows in DS.
    File.open(File.join(MASTERS_MOCK_PATH, 'NTFS', 'Windows7-x64-bootcamp4.i386.disk0s3.bcd'), 'w') do |f|
      f.write 'W7 Boot configuration database mock'
    end

    File.open(File.join(MASTERS_MOCK_PATH, 'NTFS', 'Windows7-x64-bootcamp4.i386.disk0s3.bootstrap'), 'w') do |f|
      f.write 'W7 Bootstrap mock'
    end

    File.open(File.join(MASTERS_MOCK_PATH, 'NTFS', 'Windows7-x64-bootcamp4.i386.disk0s3.id'), 'w') do |f|
      f.write 'W7 ID mock'
    end

    File.open(File.join(MASTERS_MOCK_PATH, 'NTFS', 'Windows7-x64-bootcamp4.i386.disk0s3.ntfs.dmg'), 'w') do |f|
      f.write 'W7 NTFS filesystem mock'
    end
  end

  before(:each) do
    mock_masters
  end

  describe '/get/all' do
    before do
      get '/masters/get/all', { 'id' => 'ADMINSERIAL' }
    end

    it_behaves_like 'a binary plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains one key for each mock image' do
        expect(plist_hash).to have_key('mock.hfs.dmg')
        expect(plist_hash).to have_key('Windows7-x64-bootcamp4.i386.disk0s3.ntfs.dmg')
      end

      it 'does not contain other NTFS image elements such as the BCD' do
        expect(plist_hash).to_not have_key('Windows7-x64-bootcamp4.i386.disk0s3.bcd')
        expect(plist_hash).to_not have_key('Windows7-x64-bootcamp4.i386.disk0s3.bootstrap')
        expect(plist_hash).to_not have_key('Windows7-x64-bootcamp4.i386.disk0s3.id')
      end

      it 'does not contain the mock image with incorrect naming protocol' do
        expect(plist_hash).to_not have_key('wrongextension.dmg')
      end

      it 'contains the mock image with a valid `filesystem` key' do
        expect(plist_hash['mock.hfs.dmg']).to have_key('filesystem')
        expect(plist_hash['mock.hfs.dmg']['filesystem']).to eql('HFS')
      end

      it 'contains the mock image with a valid `modificationdate` key' do
        expect(plist_hash['mock.hfs.dmg']).to have_key('modificationdate')
        expect(plist_hash['mock.hfs.dmg']['modificationdate']).to be_a_kind_of(Time)
      end

      it 'contains the mock image with a valid `size` key' do
        expect(plist_hash['mock.hfs.dmg']).to have_key('size')
        expect(plist_hash['mock.hfs.dmg']['size']).to be_a_kind_of(String)
        # TODO: expect match regex for 4000.1 (MB)
      end

      it 'contains the mock image with a valid `creationdate` key' do
        expect(plist_hash['mock.hfs.dmg']).to have_key('creationdate')
        expect(plist_hash['mock.hfs.dmg']['creationdate']).to be_a_kind_of(Time)
      end

      it 'contains the mock image with a valid `architecture` key' do
        expect(plist_hash['mock.hfs.dmg']).to have_key('architecture')
        expect(plist_hash['mock.hfs.dmg']['architecture']).to eql('PC')
      end

      # TODO: Must test for URI when repo is hosted elsewhere
      it 'contains the mock image with a valid `path` key' do
        expect(plist_hash['mock.hfs.dmg']).to have_key('path')
        expect(plist_hash['mock.hfs.dmg']['path']).to eql(File.join(MASTERS_MOCK_PATH, 'HFS', 'mock.hfs.dmg'))
      end

      it 'contains the mock image with a valid `name` key that matches the filename' do
        expect(plist_hash['mock.hfs.dmg']).to have_key('name')
        expect(plist_hash['mock.hfs.dmg']['name']).to eql('mock.hfs.dmg')
      end
    end
  end

  describe '/get/all?keywords=HFS' do
    before do
      get '/masters/get/all', { 'keywords' => 'HFS' }
    end

    it_behaves_like 'a binary plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'does not contain any entries that have a filesystem other than HFS' do
        plist_hash.each do |k,v|
          expect(v['filesystem']).to eql('HFS')
        end
      end
    end
  end

  describe '/get/all?keywords=NTFS' do
    before do
      get '/masters/get/all', { 'keywords' => 'NTFS' }
    end

    it_behaves_like 'a binary plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'does not contain any entries that have a filesystem other than NTFS' do
        plist_hash.each do |k,v|
          expect(v['filesystem']).to eql('NTFS')
        end
      end
    end
  end

  # Note: the FAT and DEV filesystems have been omitted intentionally. I dont have a test setup for these.

  describe '/get/all?keywords=mock' do
    before do
      get '/masters/get/all', { 'keywords' => 'mock' }
    end

    it_behaves_like 'a binary plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains only the mock image' do
        plist_hash.include?('mock.hfs.dmg')
      end
    end
  end

  describe '/get/entry' do

  end

  describe '/compress/entry' do

  end

  describe '/del/entry' do
    # delete using id param
    # responds 201 no body
    # updates keywords.plist
    before do
      post '/masters/del/entry', { 'id' => 'mock.hfs.dmg' }
    end

    it_behaves_like 'a successful post'

    it 'should delete the file from the filesystem' do
      expect(File.exists?(File.join(MASTERS_MOCK_PATH, 'HFS', 'mock.hfs.dmg'))).to be false
    end

    it 'should ensure that the key is removed from keywords.plist' do

    end
  end

  describe '/ren/entry' do
    before do
      post '/masters/ren/entry', { 'id' => 'mock.hfs.dmg', 'new_id' => 'mock_renamed.hfs.dmg' }
    end

    it_behaves_like 'a successful post'

    it 'renames the mock master image' do
      expect(File.exists?(File.join(MASTERS_MOCK_PATH, 'HFS', 'mock.hfs.dmg'))).to be false
      expect(File.exists?(File.join(MASTERS_MOCK_PATH, 'HFS', 'mock_renamed.hfs.dmg'))).to be true
    end

    it 'renames the entry in keywords.plist' do

    end
  end

  describe '/scan/entry' do

  end

  describe '/set/entry (DISABLED)' do
    let(:bplist_master_disable) {
      { 'status' => 'DISABLED' }.to_plist(plist_format: CFPropertyList::List::FORMAT_BINARY)
    }

    before do
      # To unpublish or publish a master, a bplist is given with key 'status' and value string of DISABLED or ENABLED
      # At the root of the masters dir is a plist containing a cached listing of all the masters in the same structure as
      # /get/all. If you disable an image, the relevant entry gets a status -> "DISABLED" kv pair. it gets deleted if you re-enable the image
      post '/masters/set/entry', bplist_master_disable, { 'CONTENT_TYPE' => 'text/xml;charset=utf8' }
    end

    it_behaves_like 'a successful post'

    it 'should add the status: DISABLED key value pair to keywords.plist' do

    end
  end

  describe '/set/entry (ENABLED)' do

    it 'should remove the status: DISABLED key value pair from keywords.plist' do

    end
  end

  describe '/set/entry keywords' do
    # POST's a keywords -> string dict.
    # For the relevant entry in keywords.plist, sets a key called keywords with a string value

  end

  # TODO: Set access group on Master

  # TODO: Test actions taken by runtime creating new masters

  describe '/workinprogress/finalize' do

  end
end