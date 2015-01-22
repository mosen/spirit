Spirit::App.controllers :masters do

  get '/get/all' do
    filesystem = params[:keywords]

    list = Spirit::Master.all_dict(filesystem)

    list.to_plist
  end

  get '/get/entry' do
    500
  end

  post '/compress/entry' do
    500
  end

  post '/del/entry' do
    master = Spirit::Master.new params[:id]
    Spirit::Master.delete(master)

    201
  end

  post '/ren/entry' do
    master = Spirit::Master.new params[:id]
    master.rename! params[:new_id]

    201
  end

  post '/scan/entry' do
    500
  end

  post '/set/entry' do
    500
  end

  post '/workinprogress/finalize' do
    500
  end


end
