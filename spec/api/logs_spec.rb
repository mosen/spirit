require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

describe '/logs' do

  describe '/set/entry' do
    before do
      post '/logs/set/entry', { 'id' => 'W1111GTM4QQ' } # TODO: post body
    end
  end

  describe '/rotate/entry' do
    before do
      post '/logs/rotate/entry', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'an xml plist post'
  end

end