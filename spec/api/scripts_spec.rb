require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/scripts' do

  describe '/get/all' do
    before do
      get '/scripts/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist response'

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

    it_behaves_like 'an xml plist response'

    context 'with parsed plist response' do
      include_context 'with parsed plist response'

      it 'contains a script key' do
        expect(plist_hash['script']).to be
      end
    end
  end

  describe '/del/entry' do

  end

  describe '/ren/entry' do

  end

  describe '/set/entry' do
    before do
      post '/scripts/set/entry', { 'id' => 'mock_post.sh' } # TODO: contents in post body
    end

    it_behaves_like 'an xml plist post'
  end

end