require 'spec_helper'

describe '/computers' do

  describe '/get/all' do
    before do
      get '/computers/get/all'
    end

    it "responds without error" do
      authorize "admin", "secret"
      get '/computers/get/all'

      last_response.status.must_equal 200
      last_response.header['Content-Type'].should eq('text/xml')
    end
  end

end
