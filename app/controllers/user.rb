Spirit::App.controllers :user do

  get '/get/credentials' do
    uid = params[:uid]

    # TODO: actual levels of authorization
    data = {
        'credentials' => %w{assistant admin runtime}, # Which services can this user access?
        'date' => DateTime.now.strftime('%Y-%m-%d %H:%M:%S %z')
    }

    data.to_plist
  end


end
