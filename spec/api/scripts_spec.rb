require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

SCRIPTS_MOCK_PATH = File.expand_path(__FILE__ + '/../../../ds_repo/Scripts')
SCRIPT_MOCK_CONTENT = "#!/bin/sh\n"

describe '/scripts', fakefs: true do
  def stub_scripts
    FileUtils.mkdir_p SCRIPTS_MOCK_PATH
    File.open(File.join(SCRIPTS_MOCK_PATH, 'mock.sh'), 'w') do |f|
      f.write SCRIPT_MOCK_CONTENT
    end
  end

  before(:each) do
    stub_scripts
  end

  describe '/get/all' do
    before do
      get '/scripts/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'a binary plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains a scripts array' do
        expect(plist_hash['scripts']).to be_instance_of(Array)
      end
    end
  end

  describe '/get/entry' do
    before do
      get '/scripts/get/entry', { 'id' => 'mock.sh' }
    end

    it_behaves_like 'a binary plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains a script key' do
        expect(plist_hash['script']).to be
        expect(plist_hash['script']).to eq(SCRIPT_MOCK_CONTENT)
      end
    end
  end

  describe '/del/entry' do
    before do
      post '/scripts/del/entry', { 'id' => 'mock.sh' }
    end

    it_behaves_like 'a successful post'

    it 'removes the mock script' do
      expect(File.exists?(File.join(SCRIPTS_MOCK_PATH, 'mock.sh'))).to be_false
    end
  end

  describe '/ren/entry' do
    before do
      post '/scripts/ren/entry', { 'id' => 'mock.sh', 'newid' => 'mock_renamed.sh' }
    end

    it_behaves_like 'a successful post'

    it 'renames the mock script' do
      expect(File.exists?(File.join(SCRIPTS_MOCK_PATH, 'mock.sh'))).to be_false
      expect(File.exists?(File.join(SCRIPTS_MOCK_PATH, 'mock_renamed.sh'))).to be_true
    end
  end

  describe '/set/entry' do
    before do
      post '/scripts/set/entry?id=mock_post.sh', { 'script_file' => "#/bin/sh\n" }.to_plist(plist_format: CFPropertyList::List::FORMAT_BINARY), { 'Content-Type' => 'application/octet-stream' }
    end

    it_behaves_like 'a successful post'
  end

end