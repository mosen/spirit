Spirit::App.controllers :configurationprofiles do

  get '/get/all' do
    {
      'configuration' => [],
      'enrollment' => [],
      'trust' => []
    }.to_plist
  end

end
