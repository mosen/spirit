require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/computers' do

  describe '/get/all' do
    before do
      authorize "admin", "secret"
      get '/computers/get/all'
    end

    it_behaves_like 'an xml plist response'

    context 'with the plist result' do
      it 'contains a key `computers`' do

      end

      it 'contains a key `groups`' do

      end

      it 'contains a non empty value for the default group' do

      end
    end


  end

end
