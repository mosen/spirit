require 'spec_helper'
require 'shared_examples_http'
require 'shared_contexts'
require 'cfpropertylist'

describe '/server', use_fakefs: true do

  def mock_server
    # When stats are generated, a file is saved at Masters/keywords.plist
    # So this must be writable in FakeFS
    repo = File.expand_path(__FILE__ + '/../../../ds_repo')

    FileUtils.mkdir_p repo + '/Masters'
    FileUtils.mkdir_p repo + '/Packages'
    FileUtils.mkdir_p repo + '/Scripts'
    FileUtils.mkdir_p repo + '/Databases/Workflows'
  end

  before(:each) do
    mock_server
  end


  describe '/get/date' do

  end

  describe '/get/info' do
    before do
      get '/server/get/info'
    end

    it_behaves_like 'a binary plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains the version spirit is developing against' do
        expect(plist_hash['version']).to eql('1.6.13')
      end

      it 'contains a host_ip key' do
        expect(plist_hash['host_ip']).to be
      end

      it 'contains a protocol-version key' do
        expect(plist_hash['protocol-version']).to be
      end

      it 'contains a repository_url_preview key' do
        expect(plist_hash['repository_url_preview']).to be
      end

      it 'contains a network_interfaces key, which is a dictionary' do
        expect(plist_hash['network_interfaces']).to be
        expect(plist_hash['network_interfaces']).to be_a(Hash)
      end

      it 'contains a server_url key' do
        expect(plist_hash['server_url']).to be
      end

      it 'contains a host_system_version key' do
        expect(plist_hash['host_system_version']).to be
      end

      it 'contains a computer_primary_key key' do
        expect(plist_hash['computer_primary_key']).to be
      end

      it 'contains a multicast_stream_datarate_max key' do
        expect(plist_hash['multicast_stream_datarate_max']).to be
      end

      it 'contains a secure_server key indicating whether SSL is available YES/NO' do
        expect(plist_hash['secure_server']).to be_a(String)
      end

      it 'contains a version string' do
        expect(plist_hash['version-string']).to be
      end

      it 'contains a multicast_client_datarate_min' do
        expect(plist_hash['multicast_client_datarate_min']).to be
      end

      it 'contains a role key' do
        expect(plist_hash['role']).to be
      end

      it 'contains a host name' do
        expect(plist_hash['host_name']).to be
      end

      it 'contains a status code' do
        expect(plist_hash['status']).to be
        expect(plist_hash['status']).to be_a(Numeric)
      end

      it 'contains a server name' do
        expect(plist_hash['name']).to be
      end
    end
  end

  describe '/get/stats' do
    before do
      get '/server/get/stats', { 'id' => 'W1111GTM4QQ' }
    end

    let (:plist_hash) {
      plist = CFPropertyList::List.new(:data => last_response.body)
      CFPropertyList.native_types(plist.value)
    }

    it_behaves_like 'a binary plist response'

    it 'contains a client counter' do
      expect(plist_hash['clients']).to be
    end

    it 'contains a computers counter' do
      expect(plist_hash['computers']).to be
    end

    it 'contains a masters counter' do
      expect(plist_hash['masters']).to be
    end

    it 'contains a packages counter' do
      expect(plist_hash['packages']).to be
    end

    it 'contains a scripts counter' do
      expect(plist_hash['scripts']).to be
    end

    it 'contains a workflows counter' do
      expect(plist_hash['workflows']).to be
    end
  end

  describe '/groups/get' do

  end

  describe '/groups/get/all' do

  end

  describe '/keys/get/all' do

  end

end