require 'spec_helper'
require 'shared_examples_http'
require 'shared_contexts'

describe '/computers/groups' do


  describe '/get/all' do
    before do
      get '/computers/groups/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist response'

    context 'with the plist result' do
      include_context 'with parsed plist response'

      it 'contains a key `groups`' do
        expect(plist_hash).to have_key('groups')
      end

    end
  end

  describe '/get/default' do
    before do
      get '/computers/groups/get/default', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist response'
  end

  describe '/get/entry?id=' do
    before do
      get '/computers/groups/get/entry', { 'id' => 'MockGroup' }
    end

    it_behaves_like 'an xml plist response'
  end

  describe '/del/default' do

  end

  describe '/del/entry' do

  end

  describe '/new/entry' do

  end

  describe '/ren/entry' do

  end

  describe '/set/default' do

  end

  describe '/set/entry' do

  end

end