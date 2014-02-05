require_relative '../../lib/spirit/log'

Spirit::App.controllers :logs do

  get '/get/entry' do
    log = Spirit::Log.new params[:id]

    log_content = log.exists? ? log.contents : ''
    plist_val = {
      params[:id] => log_content
    }

    plist_val.to_plist
  end

  # NOTE: This may never be called, the DS runtime just calls set/entry every time
  post '/append/entry' do
    400
  end

  post '/del/entry' do
    log = Spirit::Log.new params[:id]
    Spirit::Log.delete(log)
    201
  end

  post '/rotate/entry' do
    id = params[:id] # Serial | Ethernet ID

    log = Spirit::Log.new id
    log.rotate! if log.exists?

    201
  end

  post '/set/entry' do
    id = params[:id] # Serial

    log = Spirit::Log.new id
    log.contents = @request_payload['log_data']

    201
  end

end
