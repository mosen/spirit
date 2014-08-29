require 'spec_helper'
require 'shared_examples_http'
require 'shared_contexts'

describe '/configurationprofiles', fakefs: true do

  # TODO: stub enrollment and trust profiles

  describe '/get/all' do
    before do
      get '/configurationprofiles/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'a binary plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains a configuration array' do
        expect(plist_hash).to have_key('configuration')
        expect(plist_hash['configuration']).to be_instance_of(Array)
      end

      it 'contains an enrollment array' do
        expect(plist_hash).to have_key('enrollment')
        expect(plist_hash['enrollment']).to be_instance_of(Array)
      end

      it 'contains a trust array' do
        expect(plist_hash).to have_key('trust')
        expect(plist_hash['trust']).to be_instance_of(Array)
      end
    end
  end

end
