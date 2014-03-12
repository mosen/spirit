require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

FILES_PATH = File.expand_path(__FILE__ + '/../../../ds_repo/Files/testfile.txt')

describe '/files', fakefs: true do
  def stub_files
    FileUtils.mkdir_p File.dirname(FILES_PATH)
    File.open File.expand_path(FILES_PATH), 'w' do |f|
      f.write('TEST')
    end
  end

  describe '/get/all' do
    before do
      stub_files

      get '/files/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains a files array' do
        expect(plist_hash).to have_key('files')
        expect(plist_hash['files']).to be_instance_of(Array)
      end

      it 'contains the mock file' do
        expect(plist_hash['files']).to include('testfile.txt')
      end
    end

  end

end